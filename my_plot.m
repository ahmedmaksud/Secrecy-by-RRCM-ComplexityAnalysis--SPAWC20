clc;

load('newtable_4_by_9_a.mat')
clr='b';

figure(1);
p1=semilogx(table(1,:),table(2,:),clr);
grid on;
hold on;
semilogx(table(1,:),table(3,:),[clr,'--']);
hold on;
xlabel('\alpha','FontSize',20)
ylabel('converged right solutions (%)','FontSize',15)


figure(2);
q1=semilogx(table(1,:),table(end,:),clr);
grid on
hold on
xlabel('\alpha','FontSize',20)
ylabel('not converged (%)','FontSize',15)
%%
figure(1)
legend([p1 p2 p3 p4],'K=9','K=11','K=14','K=19','Fontsize',12);
figure(2)
legend([q1 q2 q3 q4],'K=9','K=11','K=14','K=19','Fontsize',12,'Location','southeast');