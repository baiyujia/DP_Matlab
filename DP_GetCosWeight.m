function [weight] = DP_GetCosWeight(x,y,lastx,lasty,lastlastx,lastlasty)
    A = x+y*i;
    B = lastx+lasty*i;
    C = lastlastx+lastlasty*i;
    a=abs(B-C);
    b=abs(A-C);
    c=abs(A-B);
    if c ~= 0 && a ~= 0
       weight = -(c*c + a*a - b*b )/(2*c*a);
    else
       weight = 1;
    end
    
end