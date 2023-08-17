%_________________________________________________________________________%
%Multi-strategy improved slime mould algorithm (MSMA) ¡ªLingyun Deng,Sanyang Liu
%_________________________________________________________________________%
function [Best_pos,Best_score,curve]=MSMA(pop,Max_iter,lb,ub,dim,fobj)
tic
z=0.03; % Parameter initialization
if(max(size(ub)) == 1)
   ub = ub.*ones(1,dim);
   lb = lb.*ones(1,dim);  
end

curve=[];
%Initialization of population
X0=initialization_SMA(pop,dim,ub,lb);
X = X0;

fitness = zeros(1,pop);

%Fitness evaluation
for i = 1:pop
   fitness(i) =  fobj(X(i,:));
end
 [fitness, index]= sort(fitness);%sort the fitness value
GBestF = fitness(1);%Current best fitness

for i = 1:pop
    X(i,:) = X0(index(i),:);
end

GBestX = X(1,:);%Current best solution
W = zeros(pop,dim);%Weight matrix
curve(1) = GBestF;
l=2;
while l< Max_iter+1
    worstFitness = fitness(end);
    bestFitness = fitness(1);
    S=bestFitness-worstFitness+eps;  
    %% Calculate W
    for i = 1: pop
        if i<pop/2 
            W(i,:)= 1+rand(1,dim).*log10((bestFitness-fitness(i))/(S)+1);
        else 
            W(i,:)= 1- rand(1,dim).*log10((bestFitness-fitness(i))/(S)+1);
        end
    end
    
    % Update control parameter
    a = atanh(-(l/Max_iter)+1);   
    b = 1-l/Max_iter;
    P=exp(l/Max_iter)/3;
    %Position update
    for i=1:pop
        if rand<z 
%             X(i,:) = (ub-lb)*rand+lb;

%             A = randi([1,pop]);
%             C = randi([1,pop]);

            Candidates=[1:i-1 i+1:pop];
            idx=Candidates(randperm(pop-1,3));        
            x1=X(idx(1),:);
            x2=X(idx(2),:);
            x3=X(idx(3),:); 
            F=0.5+0.5*rand();
            X(i,:)=x1+F*(x2-x3);
            
%             X(i,:) = GBestX+b*(X(A,:)-X(C,:));
        else
            p =tanh(abs(fitness(i)-GBestF));  
            vb = unifrnd(-a,a,1,dim); 
            vc = unifrnd(-b,b,1,dim);
            for j=1:dim
                r = rand();
%                 A = randi([1,pop]);  
                B = randi([1,pop]);
                if r<p    
                    X(i,j) = GBestX(j)+ vb(j)*(W(i,j)*GBestX(j)-X(B,j));   
                else
                    X(i,j) = vc(j)*X(i,j);
                end
            end

            %% Adaptive mutation probability
            if rand<P
                X_temp=lb+rand*(ub-lb);
                f_temp=fobj(X_temp);
                if f_temp<fobj(X(i,:))
                    X(i,:)=X_temp;
                end
            end
        end
    end

   % Boundary control
   for j = 1:pop
       for a = 1: dim
           if(X(j,a)>ub(a))
               X(j,a) =ub(a);
           end
           if(X(j,a)<lb(a))
               X(j,a) =lb(a);
           end
       end
   end
  
   
   %Positions update
   for j=1:pop
       fitness(j) = fobj(X(j,:));
   end
   
   [fitness, index]= sort(fitness);%sort the fitness
   for j = 1:pop
      X(j,:) = X(index(j),:);
   end
   if(fitness(1)<GBestF)
       GBestF=fitness(1);
       GBestX = X(1,:);
   end
   
   
   %% Dynamic random search technique
   if rem(l,90)==0  % This condition can be adjusted according to the problem.
       [GBestX_temp,~]=local_search(GBestX,GBestF,fobj,dim);
       % Boundary control
       for a = 1: dim
           if(GBestX_temp(a)>ub(a))
               GBestX_temp(a) =ub(a);
           end
           if(GBestX_temp(a)<lb(a))
               GBestX_temp(a) =lb(a);
           end
       end
       %Fitness evaluation
       f=fobj(GBestX_temp);
       if f<GBestF
           GBestX=GBestX_temp;
           GBestF=f;
       end
   end
   

    curve(l)=GBestF;
    l=l+1;
   
        
 
end

Best_pos = GBestX;
Best_score = curve(end);
% toc
% disp(['The runtime of MSMA: ',num2str(toc)]);



