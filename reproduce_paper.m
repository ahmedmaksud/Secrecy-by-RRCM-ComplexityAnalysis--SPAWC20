function reproduce_paper(varargin)
% Regenerate the results of Hua and Maksud, "Unconditional Secrecy and Computational Complexity against Wireless Eavesdropping," SPAWC 2020.
%
%   reproduce_paper                      full run, all phases
%   reproduce_paper('preset','smoke')    fast sanity run
%   reproduce_paper('only','fig1')       one phase only
%   reproduce_paper('N',4,'workers',12)  attack size / pool size
%
% Two phases:
%   'attack'  Eve's Gauss-Newton attack on RRCM (Section VI-A).
%             Sweeps the reciprocity-noise level and counts how often the attack recovers the user's channel over RRR random trials.
%             Uses attaack_B's model and solver (gen_Q_data / add_noise_b / SNS_B / my_quality_control).
%   'fig1'    Figure 1: time for Eve's exhaustive search over a quantized 9x1 channel, from the measured cost of one 3x3 SVD.
%
% Results are written to results/.

p = inputParser;
p.addParameter('preset','full');
p.addParameter('only',{'attack','fig1'});
p.addParameter('N',4);
p.addParameter('workers',[]);
p.addParameter('seed',20200101);
p.parse(varargin{:});
opt = p.Results;
if ischar(opt.only) || isstring(opt.only), opt.only = cellstr(opt.only); end

here = fileparts(mfilename('fullpath'));
outdir = fullfile(here,'results');
if ~exist(outdir,'dir'), mkdir(outdir); end
set(0,'DefaultFigureVisible','off');

cfg = preset_config(opt.preset);
fprintf('reproduce_paper  preset=%s  phases=%s  N=%d\n', ...
        opt.preset, strjoin(opt.only,','), opt.N);

if ismember('attack',opt.only)
    run_attack(opt, cfg, outdir);
end
if ismember('fig1',opt.only)
    run_fig1(opt, cfg, outdir);
end
end

% ---------------------------------------------------------------------------
function cfg = preset_config(preset)
switch lower(preset)
    case 'smoke'
        cfg.RRR = 3;   cfg.beta = [0.01 0.3 1];               cfg.my_iter = 500;
        cfg.nsvd = 2^12;
    case 'quick'
        cfg.RRR = 20;  cfg.beta = [0.001 0.01 0.1 0.3 0.6 1]; cfg.my_iter = 2000;
        cfg.nsvd = 2^15;
    case 'full'
        cfg.RRR = 100; cfg.beta = [0.001 0.01 0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9 1];
        cfg.my_iter = 7000; cfg.nsvd = 2^18;
    case 'deep'
        cfg.RRR = 1750; cfg.beta = [0.001 0.01 0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9 1];
        cfg.my_iter = 7000; cfg.nsvd = 2^18;
    otherwise
        error('unknown preset %s', preset);
end
end

% ---------------------------------------------------------------------------
function run_attack(opt, cfg, outdir)
N = opt.N; M = N; L = N; Ny = 1;
K = ceil((0.5*N*(N+1)-1)/Ny) + 2;
aalpha = sqrt(cfg.beta);
eta = 0.005; tol = 2e-2;
RRR = cfg.RRR; my_iter = cfg.my_iter;
dataset_length = 2*K;
seed = opt.seed;

ensure_pool(opt.workers);

fprintf('[attack] N=%d K=%d RRR=%d iters=%d over %d noise levels\n', ...
        N, K, RRR, my_iter, numel(aalpha));
table = zeros(6, numel(aalpha));
for ia = 1:numel(aalpha)
    alpha = aalpha(ia);
    mqc = zeros(1,5);
    parfor i = 1:RRR
        rng(seed + ia*100003 + i); % worker-count-independent trials
        Qdata = gen_Q_data(M,N,L,dataset_length);
        Q = Qdata(:,:,:,1:K);
        x = gen_x_data(N);
        xprime = add_noise_b(x,alpha);
        xbarprime = get_xbar_prime_from_xprime(xprime);
        [Y,~] = get_y(Q,x);
        ya_known = my_split_1(Y,Ny);
        xest = SNS_B(Ny,Q,xbarprime,ya_known,eta,tol,my_iter);
        qc = my_quality_control(x,Qdata,xest,Ny,K,tol);
        mqc = mqc + qc;
    end
    table(:,ia) = [alpha; mqc'];
    fprintf('  beta^0.5=%.3f  recover=%3d/%d  not-conv=%3d/%d\n', ...
            alpha, mqc(4), RRR, mqc(5), RRR);
end

save(fullfile(outdir,sprintf('attack_table_N%d.mat',N)),'table','RRR','K');
write_attack_csv(table, RRR, N, outdir);
end

% ---------------------------------------------------------------------------
function write_attack_csv(table, RRR, N, outdir)
% One row per reciprocity-noise level; counts are out of RRR trials.
sqrt_beta = table(1,:).';
M = [sqrt_beta, sqrt_beta.^2, RRR*ones(size(sqrt_beta)), ...
     table(2,:).', table(3,:).', table(4,:).', table(5,:).', table(6,:).'];
cols = {'sqrt_beta','beta','trials','known_match','known_future', ...
        'hidden_known','hidden_break','not_converged'};
T = array2table(M, 'VariableNames', cols);
writetable(T, fullfile(outdir,sprintf('attack_table_N%d.csv',N)));
end

% ---------------------------------------------------------------------------
function run_fig1(opt, cfg, outdir)
% Eve's exhaustive search: N_A = 9 (h is 9x1, H_s is 3x3), S0 = 9 samples.
% With N_q quantization levels per real component there are N_q^(2*N_A) = N_q^18 candidate channels, each needing 9 SVDs of a 3x3 matrix.
% Time the 3x3 SVD, then scale by N_q^18 as in the paper: T_{Nq} = (Nq/2)^18 * T_2.
NA = 9;
nsvd = cfg.nsvd;
rng(opt.seed);
A = complex(randn(3,3,nsvd), randn(3,3,nsvd));
t0 = tic;
for k = 1:nsvd, s = svd(A(:,:,k)); end %#ok<NASGU>
per_svd = toc(t0)/nsvd;
T2 = NA * 2^(2*NA) * per_svd; % s=1..9 over 2^18 realizations

n = 3000; X = randn(n); Yb = randn(n);
tm = tic; Z = X*Yb; %#ok<NASGU>
gflops = (2*n^3)/toc(tm)/1e9; % this machine

Nq = 2:8;
scale = (Nq/2).^(2*NA);
R_this = gflops;                       % Gflops
R_pc   = 11.1;                         % paper's PC
R_sc   = 50e6;                         % 50 Petaflops
t_this = T2 * scale;
t_pc   = t_this * (R_this/R_pc);
t_sc   = t_this * (R_this/R_sc);

fprintf('[fig1] per-svd=%.3es  T2(this machine)=%.3gs  machine=%.0f Gflops\n', ...
        per_svd, T2, gflops);
save(fullfile(outdir,'fig1_data.mat'), ...
     'Nq','t_this','t_pc','t_sc','T2','gflops','per_svd');

day = 86400; year = 365*day; decade = 10*year;
f = figure('Position',[100 100 640 460]);
semilogy(Nq, t_pc, '-o', Nq, t_sc, '-s', Nq, t_this, '-d', 'LineWidth',1.4); hold on;
yline(day,   ':', '1 day');
yline(year,  ':', '1 year');
yline(decade,':', '1 decade');
grid on;
xlabel('number of quantization levels  N_q','FontSize',13);
ylabel('time required (s)','FontSize',13);
legend('11.1 Gflops PC', '50 Pflops supercomputer', ...
       sprintf('this machine (%.0f Gflops)',gflops), 'Location','northwest', 'Box','off');
title('Exhaustive search over a quantized 9x1 channel');
exportgraphics(f, fullfile(outdir,'fig1_exhaustive_time.png'), 'Resolution',150);
close(f);
end

% ---------------------------------------------------------------------------
function ensure_pool(workers)
if isempty(workers), return; end
pp = gcp('nocreate');
if isempty(pp) || pp.NumWorkers ~= workers
    delete(pp);
    parpool(workers);
end
end
