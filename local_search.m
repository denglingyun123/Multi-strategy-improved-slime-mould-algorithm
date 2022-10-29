function [x_best,f_best]=local_search(x_best,f_best,fobj,dim)%Input parameters£¬"x_best" is the current best solution£¬"fobj" is the objective function

% Parameters initialization
E=100;% Stop criterion:epoches(E)
N=10; % Number of maximum iteration(N_{local})
alpha=x_best;%Initial step size
epoch=0;% Iteration counter for local search
x_current=x_best;
f_current=f_best;
count=0;
while epoch<E
    n=0;
    while n<N %step7
        dx=2*alpha.*rand(1,dim)-alpha; %step3:Generate random vectors
        epoch=epoch+1; %step4:Update epoch
        
        f_new=fobj(x_current+dx); %step5
        count=count+1;
        if f_new<f_best
            f_best=f_new;
            x_best=x_current+dx;
            n=n+1;
            continue;
        elseif f_new<f_current
            f_current=f_new;
            x_current=x_current+dx;
            n=n+1;
            continue;
        end
        
        f_new=fobj(x_current-dx);%step6
        count=count+1;
        if f_new<f_best
            f_best=f_new;
            x_best=x_current-dx;
            n=n+1;
            continue;
        elseif f_new<f_current
            f_current=f_new;
            x_current=x_current-dx;
            n=n+1;
            continue;
        end
        
        % To avoid getting into the situation of calculating the value of the objective function all the time, the number of function evaluations is limited.
        if count>=40000
            break
        end
        
    end
    
    if count>=40000
            break
    end
    
    alpha=alpha*0.5;
end
        
        
            
            
        
    
    
    
    
            
    
    
    
