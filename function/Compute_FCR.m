
function [FCR, FCR_avg, FCR_t]=Compute_FCR(f,w)

for k=1:max(size(w))-1
    FCR_t(k)=f(k)/(w(k+1)-w(k));
end

FCR_avg=mean(FCR_t);
FCR=sum(f)/(w(end)-w(1))
end