function fuzzII=FuzzyII_Imp(g,alpha)

    mx=max(g(:));mn=min(g(:));
    f=(g-mn)./(mx-mn);



    n=length(f(:));
    mu=(sum(f(:))./n);

    std=sqrt((1/(n-1))*sum((f(:)-mu).^2));

    var=std.^2;

    m_high=(f.^alpha)+(1-f.^alpha).*(var.^alpha);
    m_low=((alpha.*mu)./(std+alpha)).*(f-alpha.*mu);
    fuzzII=(m_high+m_low+(var-2)*m_high.*m_low)./(1-(1-var)*m_high.*m_low);


    gamma_value=1.5*alpha;
    max_img=max(fuzzII(:));
    fuzzII=(max_img*(fuzzII/max_img).^gamma_value);