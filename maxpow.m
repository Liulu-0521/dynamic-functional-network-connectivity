function [ result ] = maxpow( data , time )
    %% n21
    %  max power

    t=time(end);
    pow=sum(data.^2,2)./t;

    [m,n]=max(pow);

    result=data(n,:);
end