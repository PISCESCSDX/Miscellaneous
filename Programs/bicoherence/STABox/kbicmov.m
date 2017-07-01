function[] = kbicmov(filename, moviename)

% kbicmov creates an AVI movie showing the time evolution
% of the total k-bicoherence, k-spectrum, and summed k-bicoherence
% filename : string with the name of the bicoherence data, created with
%            kbictot.m
% moviename: name of the movie going to be created 
%            (default is 'kbicsum.avi')
%
% example: kbicmov('wavkbic.mat','film.avi')
%
% F. Brochard   - revised 09/06

if nargin<2
    name='kbicsum.avi';
else
    name=moviename;
end
delete(name)

file = load(filename);

% we remove the extension '.mat' of the filename to obtain the field name:
lname=length(filename); filename=filename(1:lname-4);

spec_tim=   file.(filename).spectime;
sum2bic_tim=file.(filename).sumbtime;
sum2err =   file.(filename).serr;
k1      =   file.(filename).kax;
tscale  =   file.(filename).t;
bictot  =   file.(filename).btot;

% total error
finite = isfinite(sum2err);
ind = find(finite); minind = min(ind); maxind = max(ind);
errtot(1:length(tscale)) = sum(sum2err(minind:maxind));

ntime=length(bictot)

spmax=max(max(spec_tim));spmin=min(min(spec_tim));
sbmax=max(max(sum2bic_tim));semax=max(sum2err);

%----- Movie Parameters ------
aviobj = avifile(name,'fps',4)
%aviobj = avifile(name, 'compression','Indeo5', 'fps', 4)

scrsz = get(0,'ScreenSize');    % size of the screen
f=figure('Position',[20 scrsz(4)/3 scrsz(3)*0.8 scrsz(4)/2])
set(gcf,'color','w');
tscale=1:ntime;

for t=1:ntime
    figure(f)
    % ---- total bicoherence ----
    subplot(121)
    plot(tscale,bictot,'b',tscale,errtot,':m')
    xlabel('Time (a.u.)','fontsize',16)
    ylabel('(b_{Tot}^{k})^{2}','fontsize',16)
    title('total k-bicoherence','fontsize',16)
    ax=axis;
    axis([1 ntime ax(3) ax(4)])
    hold on; line([t t], [ax(3) ax(4)],'linewidth',2);hold off
    
    % ---- k-spectrum and summed bicoherence ----
    sb=sum2bic_tim(t,:);
    se=sum2err;
    sp=[0 spec_tim(t,:)];
    nk=length(sb);
    kaxe=12/nk:12/nk:12;
    
    subplot(122)
    hl1 = semilogy(k1(minind:maxind),sp(minind:maxind),'r','linewidth',3);
    axis([0 8 0.1*spmin 1.1*spmax]);
    ax1 = gca;
    ylabel('S(k) (a.u.)','fontsize',16);
    set(ax1,'XColor','r','YColor','r')
    
    ax2 = axes('Position',get(ax1,'Position'),...
           'YAxisLocation','right',...
           'Color','none',...
           'XColor','k','YColor','k');
       
    hold on
    plot(k1(minind:maxind),sb(minind:maxind),'.m','Parent',ax2,'linewidth',3);
    hl2 = plot(k1,se,'.k','Parent',ax2,'linewidth',3);
    axis([0 8 0 2*max([sbmax semax])]);
    grid
    hold off
    xlabel('m','fontsize',16)
    ylabel('(b^{k}(a))^{2}','fontsize',16)
    
    F = getframe(gcf); aviobj = addframe(aviobj,F);
end

aviobj=close(aviobj);
disp(['Movie ' name ' was successfully created in directory ']), cd