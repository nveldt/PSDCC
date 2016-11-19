function transparent_lines(h,alpha)
for j=1:length(h)
    h(j).Color(4) = alpha;
end
