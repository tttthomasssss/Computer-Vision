%generate a simple image and hough transform
f=zeros(101,101);
f(80,80)=1;
f(70,70)=1;
f(100,100)=1;
f(10,10)=1;
f(50,50)=1;
%f(40:60,30)=1;
figure(1)
imshow(f);
figure(2)
[H,t,r]=hough(f);
imshow(t,r,H,[])
axis on, axis normal
xlabel('\theta'), ylabel('\rho')
