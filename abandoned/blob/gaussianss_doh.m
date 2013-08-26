function SS = gaussianss_doh(I,min_scale,max_scale,S,sigma0)

if(~isreal(I) || ndims(I) > 2)
    error('I must be a real two dimensional matrix') ;
end

scales=sigma0 * 2^(1/S) .^ (0:100);
flg = find(min_scale<=scales & scales<=max_scale);
flg = [flg(1)-2 flg(1)-1 flg flg(end)+1];
flg=flg(1<=flg);
SS.scales=scales(flg);

ftransform = fft2(I);
[ysize xsize] = size(ftransform);
[x y] = meshgrid((0 : xsize-1)-(xsize-1)/2, (0 : ysize-1)-(ysize-1)/2);
for i=1:length(SS.scales)
    s = SS.scales(i);
    s4 = SS.scales(i)^4;
    gausker = exp(-(x .^ 2 + y .^ 2) / s ^ 2 /2) / pi / s ^ 2 /2;
    SS.octave(:,:,i) = ifftshift(ifft2(fft2(gausker) .* ftransform));
    gxxker = exp(-(x .^ 2 + y .^ 2) / s ^ 2 / 0.2e1) .* (x .^ 2 - s ^ 2) / pi / s ^ 6 / 0.2e1;
    gyyker = exp(-(x .^ 2 + y .^ 2) / s ^ 2 / 0.2e1) .* (y .^ 2 - s ^ 2) / pi / s ^ 6 / 0.2e1;
    gxyker = exp(-(x .^ 2 + y .^ 2) / s ^ 2 / 0.2e1) .* x .* y / pi / s ^ 6 / 0.2e1;
    Lxx = ifftshift(ifft2(fft2(gxxker) .* ftransform));
    Lyy = ifftshift(ifft2(fft2(gyyker) .* ftransform));
    Lxy = ifftshift(ifft2(fft2(gxyker) .* ftransform));
    SS.doh(:,:,i)= (Lxx.*Lyy-Lxy.*Lxy)*s4;
    SS.Lxx(:,:,i)= Lxx;
    SS.Lyy(:,:,i)= Lyy;
    SS.Lxy(:,:,i)= Lxy;
end