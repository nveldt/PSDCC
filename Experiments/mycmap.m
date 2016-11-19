function mycmap()
colormap(redbluecmap(11));
cl=get(gca,'CLim');
m = max(abs(cl));
set(gca,'CLim',[-m,m]);

end