function AMPA_r = generate_psd(data,syn,dz,dynrange,save_figures,type)
disp(['populating ' type ' dataset...'])
num_syn = numel(fieldnames(data));
synapse = fieldnames(data);
AMPA_r = struct([]);
for i = 1:num_syn
    current_synapse = data.(synapse{i}).DockedSVData;
    particles = size(current_synapse,2)/5;
    for nparticles = 1:particles
        AMPA_r(i).pos(:,nparticles) = current_synapse(:,1+(nparticles-1)*5);
        AMPA_r(i).side(:,nparticles) = current_synapse(:,5+(nparticles-1)*5);
        AMPA_r(i).normpos(:,nparticles) = current_synapse(:,3+(nparticles-1)*5);
    end
    
    %trimming
    AMPA_r(i).side = (AMPA_r(i).side==0)*-1+AMPA_r(i).side;
    AMPA_r(i).pos(AMPA_r(i).pos==0)=nan;
    
    for j = 1:size(current_synapse,1)
        AMPA_r(i).AZ(j) = syn(i).raw_data(j).analysis_data.az.length;
    end
    
    figure(1);clf;hold on
    for k = 1:size(current_synapse,1)
        width = round(AMPA_r(i).AZ(k));
        AZline = (k-size(current_synapse,1)/2)*dz;
        AMPA_r(i).depth(k,:) = repmat(AZline,1,nparticles);
        plot(linspace(-1,1,width)*width,ones(width,1)*AZline,'color','k','linewidth',2);
        plot(AMPA_r(i).pos(k,:).*AMPA_r(i).side(k,:),repmat(AZline,1,particles),'o','linewidth',2,'color','b','markersize',10);
        xlabel('lateral [nm]')
        ylabel('depth [nm]')
        ylim(dynrange)
        drawnow
    end
    hold off
    if save_figures
        savefig(figure(1),['./Figures/' type '_synapse_' num2str(i)]);
    end
end