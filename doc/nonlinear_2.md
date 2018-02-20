## Μη-γραμμική ανάλυση 2ης χρονοσειράς

Σε αυτό το σημείο της εργασίας, αναλύουμε με μη γραμμικές μεθόδους τη δεύτερη χρονοσειρά. Στη γραμμική περίπτωση της δεύτερης χρονοσειράς καταφέραμε να εξάγουμε με επιτυχία ένα γραμμικό μοντέλο, αλλά όχι αρκετά ικανό για να περιγράψει πλήρως τη συμπεριφορά της χρονοσειράς.

Ούτε εδώ θα χρειαστεί να εξάγουμε κάποια άλλη χρονοσειρά μέσω της βασικής, ωστόσο θα πρέπει να βρούμε την υστέρηση και τη διάσταση εμβύθισης μέσω της μεθόδου των υστερήσεων. Όπως και στη μη γραμμική ανάλυση της πρώτης χρονοσειράς πρώτα κάνουμε τα διαγράμματα διασποράς. Αυτά φαίνονται στα παρακάτω σχήματα:

 Διαγράμματα | Διασποράς 
:-------------------------:|:-------------------------:
![50](../assets/scatter_2nd_xM_1_2_3.png "1"){ width=45% height=45% } | ![51](../assets/scatter_2nd_xM_1_2_4.png "2"){ width=45% height=45% }
![52](../assets/scatter_2nd_xM_1_2_5.png "3"){ width=45% height=45% } | ![53](../assets/scatter_2nd_xM_1_2_6.png "4"){ width=45% height=45% }

Και εδώ τα διαγράμματα αυτά δε μας δίνουν μία τόσο καθαρή εικόνα ή μας βοηθούν για την διερεύνηση κατάλληλων παραμέτρων ανακατασκευής του χώρου κατάστασης στη συγκεκριμένη χρονοσειρά. Οπότε, δοκιμάζουμε να κάνουμε περισσότερα και να δούμε εάν από αυτά μπορούμε να εξάγουμε την υστέρηση $\tau$.


 Διαγράμματα  | Διασποράς  |
:-------------------------:|:-------------------------:|:-------------------------:
![54](../assets/scatter_2nd_xM_1_2.png "1"){ width=30% height=30% } | ![55](../assets/scatter_2nd_xM_1_3.png "2"){ width=30% height=30% } | ![56](../assets/scatter_2nd_xM_1_4.png "3"){ width=30% height=30% }
![57](../assets/scatter_2nd_xM_1_5.png "4"){ width=30% height=30% } | ![58](../assets/scatter_2nd_xM_1_6.png "5"){ width=30% height=30% } | ![59](../assets/scatter_2nd_xM_1_7.png "6"){ width=30% height=30% }
![60](../assets/scatter_2nd_xM_1_8.png "7"){ width=30% height=30% } | ![61](../assets/scatter_2nd_xM_1_9.png "8"){ width=30% height=30% } | ![62](../assets/scatter_2nd_xM_1_10.png "9"){ width=30% height=30% }

Επειδή δε φαίνεται να μπορέσουμε να καταλήξουμε κάπου και επειδή μπορεί η υστέρηση να είναι αρκετά μεγάλη σε τιμή δοκιμάζουμε να κάνουμε το διάγραμμα της συνάρτησης αμοιβαίας πληροφορίας. Αυτό φαίνεται στο σχήμα [26].

![Διάγραμμα συνάρτησης αμοιβαίας πληροφορίας](../assets/mutualinformation_2nd.png "Διάγραμμα συνάρτησης αμοιβαίας πληροφορίας"){ width=75% height=75% }

Από το διάγραμμα της συνάρτησης αμοιβαίας πληροφορίας παρατηρούμε ότι το πρώτο τοπικό ελάχιστο είναι για υστέρηση $\tau =20$. Οπότε, αυτή είναι και η υστέρηση που θα χρησιμοποιήσουμε παρακάτω. Σε αντίθεση με την πρώτη χρονοσειρά αυτή έχει τοπικό ελάχιστο στη συνάρτηση αμοιβαίας πληροφορίας. Επιπλέον, θα χρειαζόμασταν πάνω από 20 διαγράμματα διασποράς για να καταλήξουμε στο ίδιο αποτέλεσμα.

Στη συνέχεια προχωράμε στην αναζήτηση της διάστασης εμβύθισης. Αρχικά για να τη βρούμε κάνουμε το διάγραμμα ψευδών γειτόνων. Αυτό φαίνεται στο σχήμα [27].

![FNN](../assets/false_nearest_calc_plot_1st.png "FNN"){ width=75% height=75% }

Σύμφωνα με το διάγραμμα ψευδών γειτόνων για $m=4$ παρουσιάζεται η πρώτη τιμή με FNN μικρότερο του 0.1, για αυτό και θα έπρεπε να διαλέξουμε αυτό. Ωστόσο, δεν αφήνουμε την ανάλυση μόνο στο διάγραμμα FNN, αλλά κάνουμε και τα διαγράμματα διασποράς για διάφορες τιμές του $m$ γύρω από το 4. 

Διαγράμματα  | Διασποράς
:-------------------------:|:-------------------------:
![65](../assets/scatter_2nd_with_tau_xM_1_2.png "1"){ width=45% height=45% } | ![66](../assets/scatter_2nd_with_tau_xM_1-3.png "2"){ width=45% height=45% }
![67](../assets/scatter_2nd_with_tau_xM_1_4.png "3"){ width=75% height=75% }

Από τα τελευταία αυτά διαγράμματα διασποράς, βλέπουμε ότι η τιμή $m=3$ είναι καλύτερη, διότι ο ελκυστής για $m=2$ ή/και $m=4$ αρχίζει και καταστρέφεται. Το ίδιο επιβεβαιώνεται από τα διαγράμματα σφάλματος πρόβλεψης. Το σφάλμα πρόβλεψης δείχνει να έχει ένα τοπικό ελάχιστο για $m=3$. Αυτό το διάγραμμα θα το δείξουμε στο τέλος της μη-γραμμικής ανάλυσης.

Το επόμενο που κάναμε ήταν να δούμε τη διάσταση συσχέτισης. Όπως και πρωτύτερα κάνουμε τα σχετικά διαγράμματα με χρήση των πακέτων tisean.

![Διάσταση συσχέτισης για διάφορα m και r](../assets/cor_dim_plot_2nd.png "Διάσταση συσχέτισης για διάφορα m και r"){ width=75% height=75% }

Από το διάγραμμα της διάστασης συσχέτισης, μπορούμε εύκολα να επιλέξουμε το $m=3$ και να δούμε ότι εκεί παρουσιάζεται χάος και μικρό όριο σφάλματος. Επίσης, γίνεται κατανοητό ότι οι κλίσεις δε συγκλίνουν, αλλά αυξάνουν καθώς το $m$ αυξάνει και επομένως η εκτίμηση του $v$ αυξάνει με το $m$. Αυτό συμβαίνει γιατί το παράθυρο χρόνου της ανακατασκευής γίνεται πολύ μεγάλο και οι αναδιπλώσεις του ελκυστή καταστρέφουν την κλιμάκωση για μεγάλα $r$. Παρόλα αυτά για $m=3$ το μοντέλο είναι χαοτικό διότι το διάστημα στο οποίο βρίσκεται μέσα η $v$ δεν εμπεριέχει ακέραιο αριθμό.

Το μόνο που μένει να κάνουμε ακόμα στο μοντέλο αυτής της χρονοσειράς είναι να δούμε την προβλεπτική του ικανότητα. Αυτή θα τη δούμε χρησιμοποιώντας κάποιο κατάλληλο τοπικό μοντέλο που βασίζεται σε κοντινότερους γείτονες. Η πρόβλεψη γίνεται για 1 έως και 10 βήματα μπροστά στο σχήμα [30] χρησιμοποιώντας τους 3 κοντινότερους γείτονες. Ως σφάλμα πρόβλεψης χρησιμοποιούμε το NRMSE, ώστε να μπορέσουμε να συγκρίνουμε και με τα γραμμικά μοντέλα, όπως και με τη μη γραμμική ανάλυση της δεύτερης χρονοσειράς.

![Μη γραμμική πρόβλεψη](../assets/local_model_fit_2nd.png "Μη γραμμική πρόβλεψη"){ width=75% height=75% }

Από ότι βλέπουμε τα αποτελέσματα πρόβλεψης είναι καλύτερα από ότι στη γραμμική ανάλυση. Αυτό συμβαίνει τόσο για T=1, όσο και για τα υπόλοιπα βήματα. Ωστόσο, οι μέθοδοι ανάλυσης ήταν αρκετά πιο ασαφής, διότι χρειάστηκε να χρησιμοποιήσουμε τη μέθοδο των υστερήσεων για τη μη γραμμική ανάλυση. Επιπλέον, αν και το αποτέλεσμα είναι ένα χαμηλο-διάστατο χαοτικό μοντέλο (ίδιο με το μη γραμμικό της πρώτης χρονοσειράς), είναι σίγουρα πιο πολύπλοκο από τα `AR(2)` και `ARMA(2,3)` που είχαμε στο γραμμικό κομμάτι της γραμμικής ανάλυσης της δεύτερης χρονοσειράς. Ωστόσο, η προβλεπτική ικανότητα μας οδηγεί να πούμε ότι το σύστημα μπορεί να μοντελοποιηθεί καλύτερα με ένα μη γραμμικό μοντέλο όπως αυτό και μάλιστα παρουσιάζει και χαοτική συμπεριφορά. Δυστυχώς, η προβλεπτική του ικανότητα είναι χειρότερη του πρώτου, αλλά είναι σημαντικό ότι παρουσιάζει μία ανοδική ευθεία στο διάγραμμα διάστασης συσχέτισης $v(m)$ και επιπλέον η συνάρτηση αμοιβαίας πληροφορίας παρουσιάζει ελάχιστο. Αυτά τα δύο τελευταία μας κάνουν να χαρακτηρίσουμε αυτό το σύστημα πιο εύκολα μη-γραμμικό από ότι αυτό της πρώτης χρονοσειράς. Οπότε, από όλη την ανάλυση της δεύτερης χρονοσειράς μπορούμε να πούμε ότι είναι ένα αιτιοκρατικό σύστημα, χαμηλής διάστασης και μικρής πολυπλοκότητας. 

Επιπλέον η μη-γραμμική δυναμική του συστήματος αυτού φαίνεται να είναι ασθενέστερη από ότι του πρώτου. Αυτό φαίνεται από την προβλεπτική ικανότητά του, η οποία είναι υποδεέστερη του πρώτου. Επίσης, από τη διάσταση συσχέτισης και από το σχετικό άρθρο που δόθηκε μπορούμε να πούμε πως αυτή η χρονοσειρά παρουσιάζει μεγαλύτερες τιμές διάστασης συσχέτισης οπότε αφορά τον υγιή άνθρωπο σε αντίθεση με την υπόθεσή μας αρχικά.

### Ο κώδικας μη-γραμμικής ανάλυσης της 2ης χρονοσειράς

```matlab
TS_NUM = '2nd'; % '2nd'
xV = X2;

m_max = 5; % this is precalculated by seeing the various scatter plots

xM = embedDelays(xV, m_max, 2);
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
best_tau = 20;
if(FIND_BEST_TAU)
  tmax = 100;
  [mutM,f] = mutualinformation(xV, tmax);
  saveas(f, sprintf('assets/mutualinformation_%s.png', TS_NUM));
  best_tau = 20; % there is the first local minimum
end
tau = best_tau;


xM = embedDelays(xV, m_max, tau);
if(SCATTER_DIAGRAMS_PLOT)
  m = 0;
  f = plotd2d3(xM(:,1:2), sprintf('scatter-diagrams (tau=%d) for %s time series', tau, TS_NUM));
  saveas(f, sprintf('assets/scatter_%s_with_tau_xM_1_2.png', TS_NUM));
  f = plotd2d3(xM(:,1:3), sprintf('scatter-diagrams (tau=%d) for %s time series', tau, TS_NUM));
  saveas(f, sprintf('assets/scatter_%s_with_tau_xM_1-3.png', TS_NUM));
  f = plotd2d3([xM(:,1), xM(:,4)], sprintf('scatter-diagrams (tau=%d) for %s time series,lag=3', tau, TS_NUM));
  saveas(f, sprintf('assets/scatter_%s_with_tau_xM_1_4.png', TS_NUM));    
end

if(FALSE_NEAREST_CALC_PLOT)
  m_max = 20;
  [fnnM,mdistV,sddistV,f] = falsenearest(xV, tau, m_max, 10, 0, sprintf('FNN for %s time-series', TS_NUM));
  saveas(f, sprintf('assets/false_nearest_calc_plot_%s.png', TS_NUM));
end

if(DBSCAN_CLUSTERING)
  epsilon=0.5;
  MinPts=10;
  IDX=DBSCAN(xM,epsilon,MinPts);
  %% Plot Results
  f = figure();
  subplot(2,1,1);
  PlotClusterinResult(xM(:,1:3), IDX);
  title(['DBSCAN Clustering (m=', 3,', \epsilon = ' num2str(epsilon) ', MinPts = ' num2str(MinPts) ')']);
  subplot(2,1,2);
  PlotClusterinResult(xM(:,1:4), IDX);
  title(['DBSCAN Clustering (m=', 4,', \epsilon = ' num2str(epsilon) ', MinPts = ' num2str(MinPts) ')']);
  saveas(f, sprintf('assets/DBSCAN_%s.png', TS_NUM));
end

best_m = 3; % because false nearest says so (FNN is below 0.1)


% calculate correlation dimension
if(CALCULATE_CORRELATION_DIMENSION)
  mmax = 10;
  f = correlationdimension(xV, tau, mmax,' ');
  saveas(f, sprintf('assets/cor_dim_plot_%s.png', TS_NUM));
end


% train a local model
if(TRAIN_LOCAL_MODEL)
  k = 3; % stands for k in k-nn
  q = 1;
  Tmax = 10;
  [nrmseV,~,f] = localpredictnrmse(xV, TEST_SET_LENGTH, tau, best_m, Tmax, k, 1,'local-model-fit_1');
  saveas(f, sprintf('assets/local_model_fit_%s.png', TS_NUM));
end
```

