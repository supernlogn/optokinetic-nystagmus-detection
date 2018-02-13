## Μη-γραμμική ανάλυση 1ης χρονοσειράς

Σε αυτό το σημείο της εργασίας, αναλύουμε με μη γραμμικές μεθόδους την πρώτη χρονοσειρά. Όπως έδειξε η προηγούμενη ανάλυση το μοντέλο δεν μπόρεσε να εξηγηθεί με βάση τα γραμμικά εργαλεία. Οπότε, προχωράμε στη μη γραμμική μελέτη αυτής.

Στα πρώτα βήματα δε θα χρειαστεί να εξάγουμε κάποια άλλη χρονοσειρά μέσω της βασικής, ωστόσο θα πρέπει να βρούμε την υστέρηση και τη διάσταση εμβύθισης μέσω της μεθόδου των υστερήσεων. Για να έχουμε μια εποπτεία για τα μη γραμμικά μεγέθη της χρονοσειράς κάνουμε διαγράμματα διασποράς στις δύο και στις τρεις διαστάσεις. Τα διαγράμματα αυτά φαίνονται στα παρακάτω σχήματα:

 Διαγράμματα | Διασποράς 
:-------------------------:|:-------------------------:
![31](../assets/scatter_1st_xM_1_2_3.png "1"){ width=45% height=45% } | ![32](../assets/scatter_1st_xM_1_2_4.png "2"){ width=45% height=45% }
![33](../assets/scatter_1st_xM_1_2_5.png "3"){ width=45% height=45% } | ![34](../assets/scatter_1st_xM_1_2_6.png "4"){ width=45% height=45% }


Τα διαγράμματα διασποράς δε μας δίνουν μία τόσο καθαρή εικόνα ή μας βοηθούν για την διερεύνηση κατάλληλων παραμέτρων ανακατασκευής του χώρου κατάστασης στη συγκεκριμένη χρονοσειρά. Για αυτό προχωρούμε στη χρήση του διαγράμματος συνάρτησης αμοιβαίας πληροφορίας.

![Διάγραμμα συνάρτησης αμοιβαίας πληροφορίας](../assets/mutualinformation_1st.png "Διάγραμμα συνάρτησης αμοιβαίας πληροφορίας"){ width=75% height=75% }

Αν η χρονοσειρά μπορούσε να εξηγηθεί από μη-γραμμική μοντελοποίηση, τότε η συνάρτηση αμοιβαίας πληροφορίας θα έπρεπε να παρουσιάζει ένα τοπικό ελάχιστο. Παρόλα αυτά στο διάγραμμα δε διακρίνεται κάποιο τοπικό ελάχιστο, αλλά μόνο ότι η συνάρτηση είναι φθίνουσα. Για να σιγουρευτούμε περί αυτού και να δούμε αν μπορούμε να συνεχίσουμε την μη γραμμική ανάλυση κάνουμε και επιπλέον διαγράμματα 2 διαστάσεων για πιο μεγάλους χρόνους υστέρησης. Αυτά φαίνονται στα παρακάτω σχήματα:

 Διαγράμματα               |Διασποράς  |
:-------------------------:|:-------------------------:|:-------------------------:
![36](../assets/scatter_1st_xM_1_2.png "1"){ width=30% height=30% } | ![37](../assets/scatter_1st_xM_1_3.png "1"){ width=30% height=30% } | ![38](../assets/scatter_1st_xM_1_4.png "1"){ width=30% height=30% }
![39](../assets/scatter_1st_xM_1_5.png "1"){ width=30% height=30% } | ![39](../assets/scatter_1st_xM_1_6.png "1"){ width=30% height=30% } | ![40](../assets/scatter_1st_xM_1_7.png "1"){ width=30% height=30% }
![41](../assets/scatter_1st_xM_1_8.png "1"){ width=30% height=30% } | ![42](../assets/scatter_1st_xM_1_9.png "1"){ width=30% height=30% } | ![43](../assets/scatter_1st_xM_1_10.png "1"){ width=30% height=30% }

Από αυτά καταλαβαίνουμε πως η μη-γραμμική ανάλυση που θα πραγματοποιήσουμε στη συνέχεια, πολύ πιθανόν να αποτύχει. Για την επιλογή του $\tau$ παίρνουμε την τιμή που η $I(\tau)$ κάνει αγκώνα. Δηλαδή $\tau=10$. 

Στη συνέχεια κάνουμε και άλλα διαγράμματα για να δείξουμε τη διάσταση εμβύθισης. Από ότι παρατηρούμε βέβαια δεν υπάρχει κάποιος ελκυστής ο οποίος να έχει κάποιο συγκεκριμένο σχήμα. Για να δούμε καλύτερα ότι υπάρχει ελκυστής και που ακριβώς είναι τοποθετημένος στα διαγράμματα χρησιμοποιούμε τη μέθοδο των ψευδών γειτόνων. 

![FNN](../assets/false_nearest_calc_plot_1st.png "FNN"){ width=75% height=75% }

Διαγράμματα  | Διασποράς |
:-------------------------:|:-------------------------:|:-------------------------:
![45](../assets/scatter_1st_with_tau_xM_1_2.png "1"){ width=45% height=45% } | ![46](../assets/scatter_1st_with_tau_xM_1-3.png "2"){ width=45% height=45% }
![47](../assets/scatter_1st_with_tau_xM_1_4.png "3"){ width=75% height=75% }


Τελικά, διαλέγουμε διάσταση εμβύθισης $m=3$ χρησιμοποιώντας τη μέθοδο των υστερήσεων και όχι τους ψευδείς γείτονες. Αυτό γίνεται γιατί παρόλο που οι ψευδείς γείτονες απαιτούν $m\geq 5$, όταν βάζουμε $m>3$ στα διαγράμματα διασποράς τα σημεία απλώνονται περισσότερο στον χώρο. Για να επαληθεύσουμε την επιλογή μας πραγματοποιούμε και υπολογισμό της διάστασης συσχέτισης για διαφορετικές 
διαστάσεις εμβύθισης και κατάλληλη παράμετρο υστέρησης (για τώρα $\tau=10$). Η διάσταση συσχέτισης προκύπτει να είναι μία ευθεία για τις πρώτες 7 τιμές του $m$ και μετά μία άλλη ευθεία για την οποία όμως υπάρχει μεγάλη ασάφεια για τις ακριβείς τιμές για την τιμή της $v$. Δηλαδή στη δεύτερη ευθεία $v = v\pm \delta , \delta \geq 0$. Η πρώτη ευθεία δείχνει την ύπαρξη χάους στη χρονοσειρά πάντα δεδομένου των $tau$ και $m$.


![Διάσταση υστέρησης για διάφορα m και r](../assets/cor_dim_plot_1st.png "Διάσταση υστέρησης για διάφορα m και r"){ width=75% height=75% }

Το μόνο που μένει να κάνουμε ακόμα στο μοντέλο αυτής της χρονοσειράς είναι να δούμε την προβλεπτική του ικανότητα. Αυτή θα τη δούμε χρησιμοποιώντας κάποιο κατάλληλο τοπικό μοντέλο που βασίζεται σε κοντινότερους γείτονες. Η πρόβλεψη γίνεται για 1 έως και 10 βήματα μπροστά στο Σχήμα [23] χρησιμοποιώντας τους 3 κοντινότερους γείτονες. Ως σφάλμα πρόβλεψης χρησιμοποιούμε το NRMSE, ώστε να μπορέσουμε να συγκρίνουμε και με τα γραμμικά μοντέλα.


![Μη γραμμική πρόβλεψη](../assets/local_model_fit_1st.png "Μη γραμμική πρόβλεψη"){ width=75% height=75% }

Αν και στην αρχή ήμασταν διστακτικοί για τα αποτελέσματα της μη γραμμικής ανάλυσης,
τα αποτελέσματα δείχνουν να είναι σίγουρα καλύτερα από ότι η γραμμική ανάλυση αυτής της χρονοσειράς. Βέβαια, στην γραμμική περίπτωση ουσιαστικά αναλύαμε μία σειρά τοπικών ακροτάτων. Ενώ στην πρώτη η πρόβλεψη αποτύγχανε να βρει το πλάτος για τη σειρά και μπορούσε να βρει μόνο τα χρόνο εμφάνισης του ακρότατου για T=1 με αρκετά υψηλό σφάλμα, εδώ η πρόβλεψη μπορεί να βρει ουσιαστικά και τα δύο με τουλάχιστον υποτετραπλάσιο σφάλμα για T=1. Επίσης, η πρόβλεψη είναι καλύτερη από την χρήση μέσης τιμής για μέχρι και 6 βήματα. Ο ασθενής σε αυτή την περίπτωση φαίνεται να είναι ασθενής λόγω των μικρών τιμών της διάστασης υστέρησης σε σχέση με τη δεύτερη χρονοσειρά(θα δειχθεί παρακάτω) και το σύστημα είναι χαμηλής διάστασης και μικρής πολυπλοκότητας ($m=3$, $k=3$, $q=1$), ωστόσο το ότι δεν παρουσιάζει τοπικό ελάχιστο στη συνάρτηση αμοιβαίας πληροφορίας δείχνει ???????. 

### Ο κώδικας μη-γραμμικής ανάλυσης της 1ης χρονοσειράς

```matlab
TS_NUM = '1st'; % '2nd'
xV = X1;

m_max = 6; % this is precalculated by seeing the various scatter plots

xM = embedDelays(xV, m_max, 1);
if(SCATTER_DIAGRAMS_PLOT)
  f = plotd2d3(xM(:,1:3),...
               sprintf('Multi dimensional scatter-diagrams for %s time series',...
               TS_NUM));
  saveas(f, sprintf('assets/scatter_%s_xM_1_2_3.png', TS_NUM));
  f = plotd2d3(xM(:,1:4),...
               sprintf('Multi dimensional scatter-diagrams for %s time series',...
               TS_NUM));
  saveas(f, sprintf('assets/scatter_%s_xM_1_2_4.png', TS_NUM));
  f = plotd2d3(xM(:,1:5),...
               sprintf('Multi dimensional scatter-diagrams for %s time series',...
               TS_NUM));
  saveas(f, sprintf('assets/scatter_%s_xM_1_2_5.png', TS_NUM));
  f = plotd2d3(xM,...
               sprintf('Multi dimensional scatter-diagrams for %s time series',...
               TS_NUM));
  saveas(f, sprintf('assets/scatter_%s_xM_1_2_6.png', TS_NUM));  
end
if(MORE_SCATTER_DIAGRAMS_PLOT)
  xM2 = embedDelays(xV, 10, 1);
  f = plotd2d3(xM2(:,1:2),...
              sprintf('Multi dimensional scatter-diagrams for %s time series tau = 1',...
              TS_NUM));
  title(sprintf('Multi dimensional scatter-diagrams for %s time series τ = 1', TS_NUM),...
        'Interpreter','latex');
  saveas(f, sprintf('assets/scatter_%s_xM_1_2.png', TS_NUM));
  f = plotd2d3([xM2(:,1) xM2(:,3)],...
              sprintf('Multi dimensional scatter-diagrams for %s time series tau = 2',...
              TS_NUM));
  title(sprintf('Multi dimensional scatter-diagrams for %s time series τ = 2', TS_NUM),...
        'Interpreter','latex');
  saveas(f, sprintf('assets/scatter_%s_xM_1_3.png', TS_NUM));
  f = plotd2d3([xM2(:,1) xM2(:,4)],...
              sprintf('Multi dimensional scatter-diagrams for %s time series tau = 3',...
              TS_NUM));
  title(sprintf('Multi dimensional scatter-diagrams for %s time series τ = 3', TS_NUM),...
        'Interpreter','latex');
  saveas(f, sprintf('assets/scatter_%s_xM_1_4.png', TS_NUM));
  f = plotd2d3([xM2(:,1) xM2(:,5)],...
              sprintf('Multi dimensional scatter-diagrams for %s time series tau = 4',...
              TS_NUM));
  title(sprintf('Multi dimensional scatter-diagrams for %s time series τ = 4', TS_NUM),...
        'Interpreter','latex');
  saveas(f, sprintf('assets/scatter_%s_xM_1_5.png', TS_NUM));
  f = plotd2d3([xM2(:,1) xM2(:,6)],...
              sprintf('Multi dimensional scatter-diagrams for %s time series tau = 5',...
              TS_NUM));
  title(sprintf('Multi dimensional scatter-diagrams for %s time series τ = 5', TS_NUM),...
        'Interpreter','latex');
  saveas(f, sprintf('assets/scatter_%s_xM_1_6.png', TS_NUM));
  f = plotd2d3([xM2(:,1) xM2(:,7)],...
              sprintf('Multi dimensional scatter-diagrams for %s time series tau = 6',...
              TS_NUM));
  title(sprintf('Multi dimensional scatter-diagrams for %s time series τ = 6', TS_NUM),...
        'Interpreter','latex');
  saveas(f, sprintf('assets/scatter_%s_xM_1_7.png', TS_NUM));
  f = plotd2d3([xM2(:,1) xM2(:,8)],...
              sprintf('Multi dimensional scatter-diagrams for %s time series tau = 7',...
              TS_NUM));
  title(sprintf('Multi dimensional scatter-diagrams for %s time series τ = 7', TS_NUM),...
        'Interpreter','latex');
  saveas(f, sprintf('assets/scatter_%s_xM_1_8.png', TS_NUM));
  f = plotd2d3([xM2(:,1) xM2(:,9)],...
              sprintf('Multi dimensional scatter-diagrams for %s time series tau = 8',...
              TS_NUM));
  title(sprintf('Multi dimensional scatter-diagrams for %s time series τ = 8', TS_NUM),...
        'Interpreter','latex');
  saveas(f, sprintf('assets/scatter_%s_xM_1_9.png', TS_NUM));
  f = plotd2d3([xM2(:,1) xM2(:,10)],...
              sprintf('Multi dimensional scatter-diagrams for %s time series tau = 9',...
              TS_NUM));
  title(sprintf('Multi dimensional scatter-diagrams for %s time series τ = 9',TS_NUM),...
        'Interpreter','latex');
  saveas(f, sprintf('assets/scatter_%s_xM_1_10.png', TS_NUM));    
end


% find best tau by using mutual information criterion
best_tau = 10;
if(FIND_BEST_TAU)
  tmax = 100;
  [mutM,f] = mutualinformation(xV, tmax);
  saveas(f, sprintf('assets/mutualinformation_%s.png', TS_NUM));
  best_tau = 10; % there is no local minimum so we choose a
                 % bending point
end
tau = best_tau;

xM = embedDelays(xV, m_max, tau);
if(SCATTER_DIAGRAMS_PLOT)
  m = 0;
  f = plotd2d3(xM(:,1:2),...
               sprintf('scatter-diagrams (tau=%d) for %s time series',...
               tau, TS_NUM));
  saveas(f, sprintf('assets/scatter_%s_with_tau_xM_1_2.png', TS_NUM));
  f = plotd2d3(xM(:,1:3),...
              sprintf('scatter-diagrams (tau=%d) for %s time series',...
              tau, TS_NUM));
  saveas(f, sprintf('assets/scatter_%s_with_tau_xM_1-3.png', TS_NUM));
  f = plotd2d3([xM(:,1), xM(:,4)],...
               sprintf('scatter-diagrams (tau=%d) for %s time series,lag=3',...
               tau, TS_NUM));
  saveas(f, sprintf('assets/scatter_%s_with_tau_xM_1_4.png', TS_NUM));    
end

if(FALSE_NEAREST_CALC_PLOT)
  m_max = 10;
  [fnnM,mdistV,sddistV,f] = falsenearest(xV, tau, m_max, 10, 0,...
                              sprintf('FNN for %s time-series',...
                              TS_NUM));
  saveas(f, sprintf('assets/false_nearest_calc_plot_%s.png', TS_NUM));
end

% Noise is the same for every plot, so it is not corelated with the input time series
% it is white noise because n --> +infty => Normalized distribution of noise.
% Its deviation is the same through the sample time.
if(DBSCAN_CLUSTERING)
    epsilon=0.5;
    MinPts=10;
    IDX=DBSCAN(xM,epsilon,MinPts);
    %% Plot Results
    f = figure();
    subplot(2,1,1);
    PlotClusterinResult(xM(:,1:3), IDX);
    title(['DBSCAN Clustering (m=' 3 ', \epsilon = ' num2str(epsilon) ', MinPts = ' num2str(MinPts) ')']);
    subplot(2,1,2);
    PlotClusterinResult(xM(:,1:4), IDX);
    title(['DBSCAN Clustering (m=' 4 ', \epsilon = ' num2str(epsilon) ', MinPts = ' num2str(MinPts) ')']);
    saveas(f, sprintf('assets/DBSCAN_%s.png', TS_NUM));
end


best_m = 3; % because when 4-th or 5-th dimension enter it causes catastrophy

% calculate correlation dimension
if(CALCULATE_CORRELATION_DIMENSION)
  mmax = 10;
  f = correlationdimension(xV, tau, mmax,' ');
  % [cor_dim,~,f] = corr_dim(xV, mmax, tau, PLOT_CORR_DIM);
  saveas(f, sprintf('assets/cor_dim_plot_%s.png', TS_NUM));
end


% train a local model
if(TRAIN_LOCAL_MODEL)
  k = 3; % stands for k in k-nn
  q = 1;
  Tmax = 10;
  [nrmseV,~,f] = localpredictnrmse(xV, TEST_SET_LENGTH, tau,...
                                   best_m, Tmax, k, 1,...
                                   'local-model-fit_1');
  saveas(f, sprintf('assets/local_model_fit_%s.png', TS_NUM));
end
```

