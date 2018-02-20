
## Γραμμική ανάλυση 1ης χρονοσειράς

Η πρώτη χρονοσειρά που μας δίνεται όπως φαίνεται από το διάγραμμά της,
δε φαίνεται να κρύβει κάποια τάση π.χ. ανοδική. Ίσως, μόνο από αυτό θα μπορούσαμε εκ των προτέρων να εξάγουμε την κατάσταση του ατόμου. Επίσης, δε φαίνεται να είναι μόνο θόρυβος. Από αυτά εκτιμάμε ότι η χρονοσειρά εμπεριέχει πληροφορία για τον ασθενή. Στο Σχήμα [2] φαίνονται σε χρονική σειρά οι 6000 τιμές του σήματος που λάβαμε από το πρώτο πείραμα.

![Χρονοσειρά 1](../assets/basic_plot_1st.png "Χρονοσειρά 1"){ width=75% height=75% }


Μπορούμε να δούμε ότι από το βήμα 1000 μέχρι περίπου το βήμα 1200 το μάτι ξεγιελιέται αρκετά, ενώ λίγο μετά επανέρχεται. Για τις άλλες χρονικές στιγμές δε θα μπορούσαμε να πούμε κάτι ξεκάθαρο. Για αυτό και θα προχωρήσουμε στην ανάλυση του πειράματος με τα εργαλεία που έχουμε διδαχθεί στο μάθημα.

### Εξαγωγή χρονοσειράς μελέτης

Με βάση τη συνάρτηση `extremes.m` που μας δόθηκε εξάγαμε όλες τις χρονοσειρές για τα τοπικά ακρότατα και τους χρόνους τους. Εκτός από τις δοκιμές για τις διάφορες παραμέτρους αυτής της συνάρτησης υλοποιήσαμε και δικά μας εργαλεία για να δούμε πρακτικά κατά πόσο η έξοδος της `extremes.m` είναι αποδεκτή. Πρώτα επειδή γνωρίζουμε ότι γίνεται χρήση ενός FIR φίλτρου και πάνω στην έξοδό του γίνεται η εύρεση των ακροτάτων θελήσαμε να εξετάσουμε την τάξη του φίλτρου. Για αυτό δοκιμάσαμε διάφορες τιμές από 5 έως 30 με βήμα 5 και καταλήξαμε ότι η τάξη 10 είναι αρκετά πιο υποσχόμενη.

#### Κώδικας ελέγχου τάξης φίλτρου :

```matlab
  b = ones(1,filterorder)/filterorder;
  xV = filtfilt(b,1,X1);
  LENGTH = length(X1);
  T = [1:LENGTH];
  if(FIR)
    f = figure();
    plot(T, xV);
    hold on;
    plot(T, xV);
  end
```
Για επιπλέον έλεγχο της διαδικασίας δημιουργήσαμε διαγράμματα τα οποία εμφανίζουν τα ακρότατα πάνω στην αρχική χρονοσειρά ως καρφιά *jacks*. Αυτά φαίνονται και στο σχήμα [3].


#### Κώδικας εξαγωγής και ελέγχου του πίνακα ακροτάτων :

```matlab
  % extract time-series
  [locextM, ~] = extremes(X1, filterorder, nsam, 0.0, timesep, 0);
  extreme_time_idx = locextM(:,1);
  extrema_values = locextM(:,2);
  minimum_or_maximum = locextM(:,3);
    
  if(EXTREMA_PLOT)
    jacks = zeros(1, LENGTH);
    jacks(extreme_time_idx) = 40;
    jacks(extreme_time_idx -1) = -40;
    if(~FIR)
      f = figure();
      plot(T, xV);
      hold on;
    end
    plot(T, jacks);
    saveas(f, sprintf('assets/jacks_%s.png', DST_NUM));
  end
```

Οι σταθερές στις οποίες καταλήξαμε για την εξαγωγή των ακροτάτων στην πρώτη χρονοσειρά είναι οι εξής:

```matlab
filterorder = 10;
nsam = 5;
timesep = 5;
```

Πέρα από τους ελέγχους, οι τελικές χρονοσειρές ακρoτάτων της βασικής χρονοσειράς ΟΚΝ δίνεται από τον παρακάτω κώδικα:

#### Κώδικας εξαγωγής των ζητούμενων χρονοσειρών, από την έξοδο της `extremes.m` :

```matlab
  AMA = X1(extreme_time_idx);
  AMA = AMA(minimum_or_maximum == 1);
  AMI = X1(extreme_time_idx);
  AMI = AMI(minimum_or_maximum == -1);
  s = min(length(AMA), length(AMI));
  AMD = abs(AMA(1:s) - AMI(1:s));

  if(minimum_or_maximum(1) == 1) % first comes the maximum
    TMI = Ts * (extreme_time_idx(2:end) - extreme_time_idx(1:end-1));
    TMA = Ts * (extreme_time_idx(3:end) - extreme_time_idx(2:end-1));
  else % first comes the minimum
    TMI = Ts * (extreme_time_idx(3:end) - extreme_time_idx(2:end-1));
    TMA = Ts * (extreme_time_idx(2:end) - extreme_time_idx(1:end-1));
  end

  TBP = Ts * (extreme_time_idx .* (minimum_or_maximum + 1) ) /2.0;
  TBP = TBP(TBP > 0);
  TBP = TBP(2:end) - TBP(1:end-1);

  if (EXTREMA_SERIES_PLOT)
    f = figure();
    extrema_series_plot(1,3,1, AMA, 'AMA');
    extrema_series_plot(1,3,2, AMI, 'AMI');
    extrema_series_plot(1,3,3, AMD, 'AMD');

    saveas(f, sprintf('assets/AM_plot_%s.png', DST_NUM));
    f = figure();
    extrema_series_plot(1,3,1, TMA, 'TMA');
    extrema_series_plot(1,3,2, TMI, 'TMI');
    extrema_series_plot(1,3,3, TBP, 'TBP');
    saveas(f, sprintf('assets/TM_plot_%s.png', DST_NUM));    
  end
```

Από αυτές τις χρονοσειρές ενδιαφερόμαστε πιο πολύ για την χρονοσειρά `AMA` και την χρονοσειρά `TMI`. Μετά από έλεγχους για ύπαρξη πληροφορίας όπως Portmanteu (βλ.παρακάτω) καταλήξαμε ότι αυτές οι δύο έχουν την περισσότερη πληροφορία και προσεγγίζονται λιγότερο από λευκό θόρυβο. Στα σχήματα [4] και [5] δίνονται τα διαγράμματα των χρονοσειρών πλάτους και χρονικών περιθωρίων.

![Μελέτη του φίλτου πριν την εξαγωγή των σειρών ακροτάτων](../assets/jacks_1st.png "jack series"){ width=75% height=75% }

![Χρονοσειρές πλάτους](../assets/AM_plot_1st.png  "Χρονοσειρές πλάτους"){ width=75% height=75% }

![Χρονοσειρές χρόνου εμφάνισης μεγίστων](../assets/TM_plot_1st.png "Χρονοσειρές χρόνου"){ width=75% height=75% }


### Κυρίως γραμμική ανάλυση

#### AMA

Στο πρώτο μέρος της γραμμικής ανάλυσης θα αναφερθούμε στη χρονοσειρά AMA που εξάγαμε. Το πρώτο μέγεθος που υπολογίσαμε για αυτήν ήταν η τάση της. Αυτό το κάναμε χρησιμοποιώντας ένα πολυώνυμο πέμπτου βαθμού. Το τελικό πολυώνυμο έδειξε ότι ο σταθερός όρος της τάσης είναι ίσος με `8.1121938` ενώ ο γραμμικός συντελεστής `0.2772935`. Οι υπόλοιποι 3 συντελεστές αυτού του πολυωνύμου βέβαια ακυρώνουν την γραμμική τάση μετά από λίγα χρονικά βήματα. Βέβαια, για να απαλείψουμε τη στοχαστική τάση χρησιμοποιήσαμε την απλή μέθοδο των διαφορών και όχι το πολυώνυμο για να ακυρώσουμε και τη στοχαστική τάση. Επίσης, βλέπουμε ότι αφού δεν υπήρχε και κάποια εποχικότητα δεν χρειάστηκε να λάβουμε επιπλέον διαφορές ή με διαφορετική απόσταση μεταξύ των δειγμάτων.

#### Κώδικας απαλοιφής τάσεων

```matlab
if(REMOVES_TREND)
  [muyV, bV] = polynomialfit(yV, POLORDER);
  % save coefficients to a file
  save(sprintf('assets/polcoeff_%s_%s.txt', name, DST_NUM), 'bV', '-ascii');
  yV_detr = yV - muyV;
  if(REMOVES_TREND_PLOT)
    f = figure();
    subplot(1,2,1);
    plot(1:length(yV), yV);
    grid on;
    title(name);
    subplot(1,2,2);
    plot(1:length(yV_detr), yV_detr);
    grid on;
    title(sprintf('%s_detr', name));
    saveas(f, sprintf('rm_trend_%s_%s.png',name, DST_NUM));    
  end
  yV_detr = yV(2:end) - yV(1:end-1);  
end

```

Μετά υπολογίσαμε και κάναμε τα γραφήματα της συνάρτησης αυτοσυσχέτισης και μερικής αυτοσυσχέτισης. Σε αυτά έχει προστεθεί και ο στατιστικός έλεγχος ανεξαρτησίας Portmanteau.  Στα σχήματα [6] και [7] φαίνονται τα διαγράμματα αυτά. Όπως μπορούμε να διακρίνουμε υπάρχουν σημαντικές αυτοσυσχετίσεις μέχρι και τη δεύτερη αυτοσυσχέτιση. Το ίδιο δέιχνουν και οι μερικές αυτοσυσχετίσεις, με κάποιες τιμές να είναι οριακά στατιστικά μηδενικές. Για αυτό και περιμένουμε τα μοντέλα να έχουν καλή προσέγγιση για χαμηλό βαθμό AR ή/και MA. 

![Συνάρτηση αυτοσυσχέτισης](../assets/autocorrelation_AMA1.png "Συνάρτηση αυτοσυσχέτισης"){ width=75% height=75% }

![Συνάρτηση μερικής αυτοσυσχέτισης](../assets/partial_autocorrelations_AMA1.png "Συνάρτηση μερικής αυτοσυσχέτισης"){ width=75% height=75% }

#### Κώδικας για τον υπολογισμό των αυτοσυσχετίσεων

```matlab
if(AUTOCORR_PLOT)
  autrocor_plot(yV_detr, name);
  portmanteauLB(yV_detr, 20, 0.05, name);
end

...

function autrocor_plot(yV, name)
  f = figure;
  autocorr(yV, 20); % 95% confidence lvls
  s = sprintf('autocorrelation of %s', name);
  title(s);
  saveas(f, sprintf('assets/autocorrelation_%s.%s', name, 'png'));
  % yVpac = acf2pacf(yVac, 1);
  f = figure;
  parcorr(yV, 20);
  s = sprintf('partial autocorrelations of %s', name)
  title(s);
  saveas(f, sprintf('assets/partial_autocorrelations_%s.%s',name,'png'));
end
```
Από τα παραπάνω καταλαβαίνουμε ότι αν χρησιμοποιήσουμε AR ή ARMA διαδικασίες για να εξηγήσουμε την συμπεριφορά της χρονοσειράς θα πρέπει το AR μέρος να έχει μέγιστο βαθμό περίπου 3. Προκειμένου να διαλέξουμε το κατάλληλο μοντέλο χρειάζεται πρώτα να πειραματιστούμε με έναν αριθμό υποψήφιων μοντέλων. Εφόσον αφαιρέσαμε την τάση και δεν βλέπουμε κάποιο άλλο είδος τάσης στις χρονοσειρές γνωρίζουμε ότι δεν έχει νόημα να χρησιμοποιήσουμε μοντέλα τύπου ARIMA με $I \neq 0$. Τώρα έχουμε διαλέξει τον χώρο αναζήτησης του βέλτιστου γραμμικού μοντέλου, το μόνο που χρειαζόμαστε ακόμα είναι το τελικό κριτήριο για την επιλογή του. Το τελικό κριτήριο επιλογής είναι το κριτήριο πληροφορίας Akaike με βάση το σφάλμα NRMSE. Στα παρακάτω διαγράμματα δείχνουμε τα κριτήρια αυτά για τα υποψήφια μοντέλα. Επίσης παρακάτω δίνουμε και το κομμάτι του κώδικα το οποίο δημιουργεί τα κριτήρια αυτά.

AIC για τα υποψήφια AR μοντέλα | AIC για τα υποψήφια MA μοντέλα
:-------------------------:|:-------------------------:
![AIC για τα υποψήφια AR μοντέλα](../assets/MA_AIC_AMA1.png "AIC για τα υποψήφια AR μοντέλα"){ width=45% height=45% }  |  ![AIC για τα υποψήφια MA μοντέλα](../assets/AR_AIC_AMA1.png "AIC για τα υποψήφια MA μοντέλα"){ width=45% height=45% } 

![AIC για τα υποψήφια μοντέλα](../assets/ARMA_AIC_AMA1.png "AIC για τα υποψήφια ARMA μοντέλα"){ width=75% height=75% }

\ 

\ 

\ 

\ 

\ 

\ 

\ 

\ 

\ 

\ 

\ 


#### Κώδικας για τα AR μοντέλα

```matlab
function ar_estimate(yV, name, T, MAX_ORDER_AR)
  nlast = ceil(0.9 * length(yV));
  NRMSE = zeros(MAX_ORDER_AR,1);
  A = zeros(MAX_ORDER_AR,1);
  for i = 1: 1: MAX_ORDER_AR
    [n, ~, ~, ~, A(i), ~, ~] = fitARMA(yV(1:nlast), i, 0, T);
    NRMSE(i) = n(end);
  end
  f = figure;
  plot(NRMSE);
  grid on;
  s = sprintf('NRMSE of %s for AR process',  name);
  title(s);
  saveas(f, sprintf('assets/AR_NRMSE_%s.%s', name, 'png'));

  f = figure;
  plot(A);
  grid on;
  s = sprintf('Akaike criterion of %s for AR process',  name);
  title(s);
  saveas(f, sprintf('assets/AR_AIC_%s.%s', name, 'png'));
  % for best MA plot nrmse prediction error for T=1, T=2
  [m best_p] = min(A(1:min(MAX_ORDER_AR,10)));
  best_p = best_p(1)
  f = predictARMAnrmse(yV, best_p, 0, 2, nlast, 'prediction error for best AR');
  saveas(f, sprintf('assets/AR_best_pred_%s.%s', name, 'png'));
end
```

#### Κώδικας για τα ΜΑ μοντέλα

```matlab 
function ma_estimate(yV, name, T, MAX_ORDER_MA)
  nlast = ceil(0.9 * length(yV));
  NRMSE = zeros(1, MAX_ORDER_MA);
  A = zeros(1, MAX_ORDER_MA);
  for j = 1: 1: MAX_ORDER_MA
    [n, ~, ~, ~, A(j), ~, ~] = fitARMA(yV(1:nlast), 0, j, T);
    NRMSE(j) = n(end);
  end
  f = figure;
  plot(NRMSE);
  grid on;
  s = sprintf('NRMSE of %s for MA process', name);
  title(s);
  saveas(f, sprintf('assets/MA_NRMSE_%s.%s', name, 'png'));
  
  f = figure;
  plot(A);
  grid on;
  s = sprintf('Akaike criterion of %s for MA process', name);
  title(s);
  saveas(f, sprintf('assets/MA_AIC_%s.%s', name, 'png'));
  % for best MA plot nrmse prediction error for T=1, T=2
  [m best_q] = min(A(:));
  best_q = best_q(1)
  f = predictARMAnrmse(yV, 0, best_q, 2, nlast, 'prediction error for best MA');
  saveas(f, sprintf('assets/MA_best_pred_%s.%s', name, 'png'));
end
```

#### Κώδικας για τα ARMA μοντέλα

```matlab
function arma_estimate(yV, name, T, MAX_ORDER_AR, MAX_ORDER_MA)
  nlast = ceil(0.9 * length(yV));
  NRMSE = zeros(MAX_ORDER_AR, MAX_ORDER_MA);
  A = zeros(MAX_ORDER_AR, MAX_ORDER_MA);
  for i = 1: 1 : MAX_ORDER_AR
    for j = 1: 1 : MAX_ORDER_MA
      [n, ~, ~, ~, A(i,j), ~, ~] = fitARMA(yV(1:nlast), i, j, T);
      NRMSE(i,j) = n(end);
    end
  end
  % plot nrmse for arma
  f = figure;
  grid on;
  hold on;
  set(gca,'xtick',1:MAX_ORDER_AR);
  xlabel('order p');
  for j = 1: 1 : MAX_ORDER_MA
    plot([1:MAX_ORDER_AR], NRMSE(:,j), 'DisplayName', sprintf('(p,q) =(*,%d)', j));
  end
  legend('show');
  s = sprintf('NRMSE of %s for ARMA process', name);
  title(s);
  saveas(f, sprintf('assets/ARMA_NRMSE_%s.%s', name, 'png'));
  % plot aic for arma
  f = figure;
  grid on;
  hold on;
  set(gca,'xtick',1:MAX_ORDER_AR);
  xlabel('order p');      
  for j = 1: 1 : MAX_ORDER_MA
    plot([1:MAX_ORDER_AR], A(:,j), 'DisplayName', sprintf('(p,q) = (*,%d)', j));
  end
  legend('show');
  s = sprintf('Akaike criterion of %s for ARMA process', name);
  title(s);
  saveas(f, sprintf('assets/ARMA_AIC_%s.%s', name, 'png'));
  % for best ARMA plot nrmse prediction error for T=1, T=2
  B = A(1:min(10, MAX_ORDER_AR),1:min(3,MAX_ORDER_MA));
  [m n] = min(B(:));
  [best_p best_q] = ind2sub(size(B), n(1));
  f = predictARMAnrmse(yV, best_p, best_q, 2, nlast, 'prediction error for best ARMA');
  saveas(f, sprintf('assets/ARMA_best_pred_%s.%s', name, 'png'));
end
```

Από τα σχήματα του AIC για τα υποψήφια μοντέλα, παρατηρούμε ότι το μοντέλο `AR(2)` παρουσιάζει τη μικρότερη τιμή του AIC. Αυτό σημαίνει ότι θα διαλέξουμε το μοντέλο `AR(2)` για να εξηγήσουμε τη συμπεριφορά αυτής της χρονοσειράς. Τέλος για αυτό το μοντέλο δίνουμε το διάγραμμα στο σχήμα [9] που παρουσιάζει κατά πόσο μπορεί να προβλέψει μελλοντικές τιμές της εισόδου.

![Προβλέψεις τιμών για το καλύτερο μοντέλο](../assets/AR_best_pred_AMA1.png "Προβλέψεις τιμών για το καλύτερο μοντέλο"){ width=75% height=75% }


Από τα σφάλματα NRMSE βλέπουμε ότι οι προβλέψεις είναι κακές τόσο για βήμα T=1 όσο και για T=2. Για αυτό και η πρόβλεψη με χρήση της μέσης τιμής δίνει καλύτερα αποτελέσματα.

\ 


#### TMI

Παρακάτω πραγματοποιούμε τα ίδια βήματα για τη χρονοσειρά `TMI`. Επειδή ο κώδικας είναι γραμμένος όλος σε συναρτήσεις σύμφωνα με τα πρότυπα του δομημένου προγραμματισμού, το μόνο που θα έπρεπε να αλλάξουμε είναι οι παραμέτροι με τους οποίους μελετάμε τη χρονοσειρά. Πρακτικά για να γίνει η γραμμική ανάλυση της χρονοσειράς `TMI` καλούμε:

```matlab
linear_analysis(TMI, 'TMI1', MAX_ORDER_AR, MAX_ORDER_MA, POLORDER, ...
                EXTREMA_PLOT, EXTREMA_SERIES_PLOT, REMOVES_TREND, ...
                REMOVES_TREND_PLOT, AUTOCORR_PLOT, AKAIKE, DST_NUM);
```

Το πολυώνυμο που προσσεγγίζει την χρονοσειρά για τη μετέπειτα αφαίρεση της τάσης έχει δύο τελευταίους όρους ίσους με:

- γραμμικός: $8.2051972\times 10^{-3}$ 
- σταθερός: $0.32034691$

Επίσης δεν φαίνεται να έχει εποχικότητα για να χρειαστεί η μέθοδος των μεγάλων διαφορών. Βέβαια, πάλι χρησιμοποιούμε απλές διαφορές για να απαλοίψουμε και τη στοχαστική τάση.

![Συνάρτηση αυτοσυσχέτισης](../assets/autocorrelation_TMI1.png "Συνάρτηση αυτοσυσχέτισης"){ width=75% height=75% }

![Συνάρτηση μερικής αυτοσυσχέτισης](../assets/partial_autocorrelations_TMI1.png "Συνάρτηση μερικής αυτοσυσχέτισης"){ width=75% height=75% }

Οι συναρτήσεις αυτοσυσχέτισης και μερικής αυτοσυσχέτισης στα σχήματα [10], [11] δείχνουν ότι υπάρχει μία αρκετά ισχυρή σχέση της τωρινής τιμής της χρονοσειράς με πολλές προηγούμενες, ώστε αυτή η σχέση να θεωρηθεί σημαντική. Αυτό είναι προβληματικό για την αναλυσή μας τουλάχιστον στο γραμμικό κομμάτι, διότι η χρονοσειρά δεν έχει αρκετό πλήθος σημείων, ώστε να μπορέσουμε να εφαρμόσουμε τόσο μεγάλα μοντέλα. Παρόλα αυτά παρακάτω μελετάμε τη συμπεριφορά των μοντέλων που μας επιτρέπει το πλήθος σημείων της χρονοσειράς να δημιουργήσουμε, βάσει της εφαρμογής του κριτηρίου AIC.

AIC για τα υποψήφια AR μοντέλα | AIC για τα υποψήφια MA μοντέλα
:-------------------------:|:-------------------------:
![AIC για τα υποψήφια AR μοντέλα](../assets/MA_AIC_TMI1.png "AIC για τα υποψήφια AR μοντέλα"){ width=45% height=45% }  |  ![AIC για τα υποψήφια MA μοντέλα](../assets/AR_AIC_TMI1.png "AIC για τα υποψήφια MA μοντέλα"){ width=45% height=45% } 


![AIC για τα υποψήφια μοντέλα](../assets/ARMA_AIC_TMI1.png "AIC για τα υποψήφια ARMA μοντέλα"){ width=75% height=75% }


![Προβλέψεις τιμών για το καλύτερο μοντέλο](../assets/ARMA_best_pred_TMI1.png "Προβλέψεις τιμών για το καλύτερο μοντέλο"){ width=75% height=75% }

H πρόβλεψη είναι καλύτερη από τη μέση τιμή για T=1 και χειρότερη στο T=2. Γενικά καταλήγουμε πως αυτή η μέθοδος μελέτης ακροτάτων για αυτή τη χρονοσειρά μπόρεσε να παράξει αποτελέσματα, αλλά όχι τόσο άξια για να πούμε ότι αντιπροσωπεύουν το μοντέλο. Αυτό βέβαια δε σημαίνει πως η μελέτη μας σταμάτησε εδώ. Στο δεύτερο κομμάτι της εργασίας θα προσπαθήσουμε να κάνουμε μία μη γραμμική ανάλυση της χρονοσειράς και να εξάγουμε αποτελέσματα για τη συμπεριφορά της.

