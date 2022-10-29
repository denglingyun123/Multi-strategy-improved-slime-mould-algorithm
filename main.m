clc
clear all
close all
SearchAgents_no=30; % Number of search agents
Function_name='F1'; % Name of the test function that can be from F1 to F23 
Max_iteration=1000; % Maximum numbef of iterations

% Load details of the selected benchmark function
[lb,ub,dim,fobj]=Get_Functions_details(Function_name);

%% Comparisons of each algorithm
Max_test=30;
for i=1:Max_test
    disp(['��',num2str(i),'��ʵ��']);
% %     Slime mould algorithm(SMA)
    [Best_pos1(i,:),Best_score1(i),SMA_curve(i,:)]=SMA(SearchAgents_no,Max_iteration,lb,ub,dim,fobj);
% %     Improved slime mould algorithm(ISMA)
    [Best_pos2(i,:),Best_score2(i),MSMA_curve(i,:)]=MSMA(SearchAgents_no,Max_iteration,lb,ub,dim,fobj); 
end

% % The comparison of final results
figure
semilogy(mean(SMA_curve),'color','[1,0.5,0]','linewidth',2.0,'Marker','s','MarkerIndices',1:50:length(mean(SMA_curve)))
hold on
semilogy(mean(MSMA_curve),'color','[0.62745,0.12549,0.94118]','linewidth',2.0,'Marker','o','MarkerIndices',1:50:length(mean(MSMA_curve)))
title('Convergence curve of F_{1}')
xlabel('Iteration');
ylabel('Fitness');
axis tight
grid off
box on 
legend('SMA','MSMA')

disp('-------------------------------------------------')
display(['SMA 30��ʵ��������Ӧ��ֵ(Best) : ', num2str(min(Best_score1))]);
display(['SMA 30��ʵ�������Ӧ��ֵ(wrost) : ', num2str(max(Best_score1))]);
display(['SMA 30��ʵ�����Ž��Ӧ��ƽ����Ӧ��ֵ(mean) : ', num2str(mean(Best_score1))]);
display(['SMA 30��ʵ���׼�std�� : ', num2str(std(Best_score1))]);

disp('-------------------------------------------------')
display(['MSMA 30��ʵ��������Ӧ��ֵ(Best) : ', num2str(min(Best_score2))]);
display(['MSMA 30��ʵ�������Ӧ��ֵ(wrost) : ', num2str(max(Best_score2))]);
display(['MSMA 30��ʵ�����Ž��Ӧ��ƽ����Ӧ��ֵ(mean) : ', num2str(mean(Best_score2))]);
display(['MSMA 30��ʵ���׼�std�� : ', num2str(std(Best_score2))]);



