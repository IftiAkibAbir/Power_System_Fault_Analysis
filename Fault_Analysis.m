clc;
clear all;
nbranch = input('How many lines in the network for zero seq? ');
disp('Enter line data')
for p=1:1:nbranch
fb = input('from bus number :');
tb = input('to bus number :');
x = input('line reactance x = ');
z = 0+i*x; %z matrix..
y = 1./z; % inverse of each z
Ldata(p,:) = [fb tb x y]; % make an matrix of all given data
end
 
fb = Ldata(:,1); % From bus number ...
tb = Ldata(:,2); % To bus number ...
x = Ldata(:,3); % reactance x
y = Ldata(:,4);
nbus = max(max(fb),max(tb));
Ybus0 = zeros(nbus,nbus);
%Formation of the off diagonal elements%
for k=1:nbranch
    if(fb(k) && tb(k)~=0)
Ybus0(fb(k),tb(k)) = Ybus0(fb(k),tb(k))-y(k);
Ybus0(tb(k),fb(k)) = Ybus0(fb(k),tb(k));
    end
end
%Formation of diagonal elements%
for m =1:nbus
for n = 1:nbranch
if fb(n) == m
Ybus0(m,m) = Ybus0(m,m)+y(n);
elseif tb(n) == m
Ybus0(m,m) = Ybus0(m,m)+y(n);
end
end
end
Ybus0
zbus0=inv(Ybus0)
nbranch = input('How many lines in the network for positive or negative seq? ');
disp('Enter line data')
for p=1:1:nbranch
fb = input('from bus number :');
tb = input('to bus number :');
x = input('line reactance x = ');
z = 0+i*x; %z matrix..
y = 1./z; % inverse of each z
Ldata(p,:) = [fb tb x y]; % make an matrix of all given data
end
 
fb = Ldata(:,1); % From bus number ...
tb = Ldata(:,2); % To bus number ...
x = Ldata(:,3); % reactance x
y = Ldata(:,4);
nbus = max(max(fb),max(tb));
Ybus1 = zeros(nbus,nbus);
%Formation of the off diagonal elements%
for k=1:nbranch
    if(fb(k) && tb(k)~=0)
Ybus1(fb(k),tb(k)) = Ybus1(fb(k),tb(k))-y(k);
Ybus1(tb(k),fb(k)) = Ybus1(fb(k),tb(k));
    end
end
%Formation of diagonal elements%
for m =1:nbus
for n = 1:nbranch
if fb(n) == m
Ybus1(m,m) = Ybus1(m,m)+y(n);
elseif tb(n) == m
Ybus1(m,m) = Ybus1(m,m)+y(n);
end
end
end
Ybus1
zbus1=inv(Ybus1)
zbus2=zbus1;
 
 
fault_bus=3;            %fault bus
 a=-0.5+0.86603*i;
 A=[1 1 1;1 a.^2 a;1 a a.^2];
 
 Vf=1+0*i;       %Prefault voltage
 IfA0=Vf/(zbus1(fault_bus,fault_bus)+zbus2(fault_bus,fault_bus)+zbus0(fault_bus,fault_bus));
 IfA=3*IfA0;
 
 %----------------For generators only-----------------------------------
Va01=-zbus0(fault_bus,1)*(IfA0)   %zero seqeuence voltage
Va11=Vf-zbus1(fault_bus,1)*(IfA0)   %positive seqeuence voltage
Va21=-zbus2(fault_bus,1)*(IfA0)    %negative seqeuence voltage
 
 
Imseq_01=-Va01/(0.04*i)   %zero seqeuence current
Imseq_11=(Vf-Va11)/(.295*i) %positive seqeuence current
Imseq_22=-Va21/(0.295*i)  %negative seqeuence current
Im1=[Imseq_01 Imseq_11 Imseq_22];
machine_currents1=A*conj(Im1')  %find all phase a,b and c currents
 
Va02=-zbus0(fault_bus,4)*(IfA0)   %zero seqeuence voltage
Va12=Vf-zbus1(fault_bus,4)*(IfA0)   %positive seqeuence voltage
Va22=-zbus2(fault_bus,4)*(IfA0)    %negative seqeuence voltage
 
 
Imseq_02=-Va02/((1/0)*i)   %zero seqeuence current
Imseq_12=(Vf-Va12)/(.1967*i) %positive seqeuence current
Imseq_22=-Va22/(0.1967*i)  %negative seqeuence current
Im2=[Imseq_02 Imseq_12 Imseq_22];
machine_currents2=A*conj(Im2') 
 
 
Va03=-zbus0(fault_bus,7)*(IfA0)   %zero seqeuence voltage
Va13=Vf-zbus1(fault_bus,7)*(IfA0)   %positive seqeuence voltage
Va23=-zbus2(fault_bus,7)*(IfA0)    %negative seqeuence voltage
 
Imseq_03=-Va03/(0.04*i)   %zero seqeuence current
Imseq_13=(Vf-Va13)/(.295*i) %positive seqeuence current
Imseq_23=-Va23/(0.295*i)  %negative seqeuence current
Im3=[Imseq_03 Imseq_13 Imseq_23];
machine_currents3=A*conj(Im3') 
 
%  Bus Voltages
for k=1:nbus
    Va0=-zbus0(fault_bus ,k)*IfA0;
    Va1=Vf-zbus1(fault_bus ,k)*IfA0;
    Va2=-zbus2(fault_bus ,k)*IfA0;
    
    Va_seq=[Va0;Va1;Va2];
    Va=A* Va_seq;
    Volt_bus(:,k)=Va
end   

