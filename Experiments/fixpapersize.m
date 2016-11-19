function fixpapersize()
h = gcf;
D = h.PaperPosition;
h.PaperSize = [D(3) D(4)];
