%_________________________________________________________________________%
%Slime mould algorithm(SMA)            %
%_________________________________________________________________________%
function [Best_pos,Best_score,curve]=SMA(pop,Max_iter,lb,ub,dim,fobj)
% tic
z=0.03; % Parameter initialization
if(max(size(ub)) == 1)
   ub = ub.*ones(1,dim);
   lb = lb.*ones(1,dim);  
end

curve=[];

%Initialization of population
X0=initialization_SMA(pop,dim,ub,lb);
X = X0;


%Fitness evaluation
fitness = zeros(1,pop);
for i = 1:pop
   fitness(i) =  fobj(X(i,:));
end

[fitness, index]= sort(fitness);% sort the fitness
GBestF = fitness(1);% Current best fitness

for i = 1:pop
    X(i,:) = X0(index(i),:);
end

GBestX = X(1,:);% Current best position
W = zeros(pop,dim);% Weight matrix
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
    
    % Control parameter
    a = atanh(-(l/Max_iter)+1);   
    b = 1-l/Max_iter;
    
    %Positions update
    for i=1:pop
        if rand<z 
            X(i,:) = (ub-lb)*rand+lb;
        else
            p =tanh(abs(fitness(i)-GBestF));  
            vb = unifrnd(-a,a,1,dim); 
            vc = unifrnd(-b,b,1,dim);
            for j=1:dim
                r = rand();
                A = randi([1,pop]);  
                B = randi([1,pop]);
                if r<p    
                    X(i,j) = GBestX(j)+ vb(j)*(W(i,j)*X(A,j)-X(B,j));
                else
                    X(i,j) = vc(j)*X(i,j);
                end
            end
        end
    end
    
   % Boundary control
   for j = 1:pop
       for a = 1: dim
           if(X(j,a)>ub)
               X(j,a) =ub(a);
           end
           if(X(j,a)<lb)
               X(j,a) =lb(a);
           end
       end
   end
   
   
   %Fitness evaluation
   for j=1:pop
    fitness(j) = fobj(X(j,:));
   end

   [fitness, index]= sort(fitness);
   for j = 1:pop
      X(j,:) = X(index(j),:);
   end
   if(fitness(1)<GBestF)
       GBestF=fitness(1);
       GBestX = X(1,:);
   end

   
   curve(l)=GBestF;
   l=l+1;
   
end

Best_pos = GBestX;
Best_score = curve(end);
% toc
% disp(['The runtime of SMA: ',num2str(toc)]);

