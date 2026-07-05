clc; clear all; close all; warning('off','all');

N=4;
M=N;L=N;
Ny=1;
K=ceil((0.5*N*(N+1)-1)/(Ny))+2;
aalpha=sqrt([0.001 0.01 0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9 1]);
eta=0.005;
tol=2*10^(-2);
my_iter=7000;
RRR=100;
dataset_length=2*K;
table=zeros(6,length(aalpha));
for ialpha=1:length(aalpha)
    alpha=aalpha(ialpha);
    clc;
    [ialpha alpha]
    mqc=zeros(1,5);
    %conv_app_right;conv_app_right_future;conv_right;conv_right_future;not_conv;
    parfor_progress(RRR);
    parfor i=1:RRR
        Qdata=gen_Q_data(M,N,L,dataset_length);
        Q=Qdata(:,:,:,1:K);
        x=gen_x_data(N);
        xprime=add_noise_b(x,alpha);
        
        xbar=x*x';
        xbarprime=get_xbar_prime_from_xprime(xprime);
        
        [Y,~]=get_y(Q,x);
        ya_known=my_split_1(Y,Ny);
        
        [xest,Yest,iter]=SNS_B(Ny,Q,xbarprime,ya_known,eta,tol,my_iter);
        
        qc=my_quality_control(x,Qdata,xest,Ny,K,tol);
        
        if qc(1)==1
            disp(iter)
        end
        
        mqc=mqc+qc;
        parfor_progress;
    end
    parfor_progress(0);
    table(:,ialpha)=[alpha;mqc'];
    save(['uniktable_',int2str(N),'_by_',int2str(K),'_b'],'table');
end
my_beep 