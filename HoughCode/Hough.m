function [h ,theta, rho]=hough(f,dtheta,drho)
%compute the Hough transform of f. dtheta is spacing in degrees and drho is
%the spacing along rho axis. h is the hough transform, theta is a vector
%containing the values for theta and rho the value for rho for the matrix
%elements in h. If dtheta and drho are not specified 1 is used.


%check the number of arguments used
if nargin<3
  drho=1;
end
if nargin<2
 dtheta=1;
end
%generate the theta and rho vectors
f=double(f);
[M,N]=size(f);
theta=linspace(-90,0,ceil(90/dtheta)+1);
theta=[theta ,-fliplr(theta(2:end-1))];
ntheta=length(theta);

D=sqrt((M-1)^2+(N-1)^2);
q=ceil(D/drho);
nrho=2*q-1;
rho=linspace(-q*drho,q*drho,nrho);

%transform input into sparse array.
[x,y,val]=find(f);
x=x-1;
y=y-1;

%init output
h=zeros(nrho,length(theta));

%to save RAM process 1000 pixels at once
for k=1:ceil(length(val)/1000);
 first=(k-1)*1000+1;
last=min(first+999,length(x));

x_matrix =repmat(x(first:last),1,ntheta);
y_matrix=repmat(y(first:last),1,ntheta);
val_matrix=repmat(val(first:last),1,ntheta);
theta_matrix=repmat(theta,size(x_matrix,1),1)*pi/180;
rho_matrix=x_matrix.*cos(theta_matrix)+y_matrix.*sin(theta_matrix);
slope=(nrho-1)/(rho(end)-rho(1));
rho_bin_index=round(slope*(rho_matrix-rho(1))+1);
theta_bin_index=repmat(1:ntheta,size(x_matrix,1),1);
%Note that sparse accumulates values when the indices are repeated
%full converts back to full matrix
h=h+full(sparse(rho_bin_index(:), theta_bin_index(:),val_matrix(:),nrho,ntheta));
end

