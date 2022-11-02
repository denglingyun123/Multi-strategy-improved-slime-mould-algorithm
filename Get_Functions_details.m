
% lb is the lower bound: lb=[lb_1,lb_2,...,lb_d]
% up is the uppper bound: ub=[ub_1,ub_2,...,ub_d]
% dim is the number of variables (dimension of the problem)

function [lb,ub,dim,fobj] = Get_Functions_details(F)

switch F
    case 'F1'%Sphere
        fobj = @F1;
        lb=-100;
        ub=100;
        dim=30;
end

end

% F1
function o = F1(x) %Sphere
o=sum((x.^2));
end

