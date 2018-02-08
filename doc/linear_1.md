## Γραμμική ανάλυση 1ης χρονοσειράς
Η πρώτη χρονοσειρά που μας δίνεται όπως φαίνεται από το διαγραμμά της,
δε φαίνεται να κρύβει κάποια τάση π.χ. ανοδική. Οπότε, μάλλον ο ασθενής είναι υγιής (αυτό θα φανεί και αργότερα, αλλά χωρίς επαρκή ανάλυση δεν θα μπορούσαμε να υποστηρίξουμε κάτι τέτοιο). Επίσης, δε φαίνεται να είναι μόνο θόρυβος. Από αυτά εκτιμάμε ότι η χρονοσειρά εμπεριέχει πληροφορία για τον ασθενή. Στο Σχήμα [1]: φαίνονται σε χρονική σειρά οι 6000 τιμές του σήματος που λάβαμε από το πρώτο πείραμα.
![Ή πρώτη χρονοσειρά](../assets/basic_plot_1st.png "Χρονοσειρά 1")


Μπορούμε να δούμε ότι από το βήμα 1000 μέχρι περίπου το βήμα 1200 το μάτι ξεγιελιέται αρκετά, ενώ λίγο μετά επανέρχεται. Για τις άλλες χρονικές στιγμές δε θα μπορούσαμε να πούμε κάτι ξεκάθαρο. Για αυτό και θα προχωρήσουμε στην ανάλυση του πειράματος με τα εργαλεία που έχουμε διδαχθεί στο μάθημα. Αρχικά θα πρέπει να παρουσιάσουμε.

### Εξαγωγή χρονοσειράς μελέτης
Με βάση τη συνάρτηση `extremes.m` που μας δόθηκε εξάγαμε όλες τις χρονοσειρές για τα τοπικά ακρότατα και τους χρόνους τους. Εκτός από τις δοκιμές για τις διάφορες παραμέτρους αυτής της συνάρτησης υλοποιήσαμε και δικά μας εργαλεία για να δούμε πρακτικά κατά πόσο η έξοδος της `extremes.m` είναι αποδεκτή. Πρώτα επειδή γνωρίζουμε ότι γίνεται χρήση ενός FIR φίλτρου και πάνω στην έξοδό του γίνεται η εύρεση των ακροτάτων θελήσαμε να εξετάσουμε την τάξη του φίλτρου. Για αυτό δοκιμάσαμε διάφορες τιμές από 5 έως 30 με βήμα 5 και καταλήξαμε ότι η τάξη 10 είναι αρκετά πιο υποσχόμενη.

#### Κώδικας ελέγχου τάξης φίλτρου :
```matlab
  b = ones(1,filterorder)/filterorder;
  xV = filtfilt(b,1,X1);
  LENGTH = length(X1);
  T = [1:LENGTH];
  if(FIR)
    hold on;
    plot(T, xV);
  end
```
Για επιπλέον έλεγχο της διαδικασίας δημιουργήσαμε διαγράμματα τα οποία εμφανίζουν τα ακρότατα πάνω στην αρχική χρονοσειρά ως καρφιά *jacks*.

#### Κώδικας εξαγωγής και ελέγχου του πίνακα ακροτάτων :
```matlab
  % extract time-series
  [locextM, ~] = extremes(X1, filterorder, nsam, 0.0, timesep, 0);
  extreme_time_idx = locextM(:,1);
  extrema_values = locextM(:,2);
  minimum_or_maximum = locextM(:,3);
    
  if(EXTREMA_PLOT) % need to have BASIC_PLOT=true to better work
    jacks = zeros(1, LENGTH);
    jacks(extreme_time_idx) = 40;
    jacks(extreme_time_idx -1) = -40;
    hold on;
    plot(T, jacks);
  end
```
Πέρα από τους ελέγχους οι τελικές χρονοσειρές ακρoτάτων της βασικής χρονοσειράς ΟΚΝ δίνεται από τον παρακάτω κώδικα:

#### Κώδικας εξαγωγής των ζητούμενων χρονοσειρών, από την έξοδο της `extremes.m` :
```matlab
  AMA = X1(extreme_time_idx);
  AMA = AMA(minimum_or_maximum == 1);
  AMI = X1(extreme_time_idx);
  AMI = AMI(minimum_or_maximum == -1);
  AMD = abs(AMA - AMI);

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

Από αυτές τις χρονοσειρές ενδιαφερόμαστε πιο πολύ για την χρονοσειρά `AMA` και την χρονοσειρά `???`. Μετά από έλεγχους για ύπαρξη πληροφορίας όπως Portmanteu καταλήξαμε ότι αυτές οι δύο έχουν την περισσότερη πληροφορία και προσεγγίζονται λιγότερο από λευκό θόρυβο. Στα σχήματα [2] και [3] δίνονται τα διαγράμματα των χρονοσειρών πλάτους και χρονικών περιθωρίων για τα διάφορα χρονικά βήματα.


![2](../assets/AM_plot_1st.png  "Χρονοσειρές πλάτους")


![3](../assets/TM_plot_1st.png "Χρονοσειρές χρόνου")

### Κυρίως γραμμική ανάλυση
#### AMA
Στο πρώτο μέρος της γραμμικής ανάλυσης θα αναφερθούμε στη χρονοσειρά AMA που εξάγαμε. Το πρώτο μέγεθος που υπολογίσαμε για αυτήν ήταν η τάση της. Αυτό το κάναμε χρησιμοποιώντας ένα πολυώνυμο. Το τελικό πολυώνυμο έδειξε ότι η τάση είναι σταθερή και ίση με `9.6349707`ενώ ο γραμμικός συντελεστής `0.95796488`. Οι υπόλοιποι 3 συντελεστές αυτού του πολυωνύμου βέβαια ακυρώνουν την γραμμική τάση μετά από λίγα χρονικά βήματα.

#### Κώδικας απαλοιφής τάσεων
```matlab
[muyV, bV] = polynomialfit(yV, POLORDER);
save(sprintf('assets/polcoeff_%s.txt', DST_NUM), 'bV', '-ascii');
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
end
```

Μετά υπολογίσαμε και κάναμε τα γραφήματα της συνάρτησης αυτοσυσχέτισης και μερικής αυτοσυσχέτισης. Στα σχήματα [4] και [5] φαίνονται τα διαγράμματα αυτά. Όπως μπορούμε να διακρίνουμε υπάρχουν σημαντικές αυτοσυσχετίσεις μέχρι και την εντέκατη αυτοσυσχέτιση. Βέβαια οι μερικές αυτοσυσχετίσεις εξηγούν ότι αυτό συμβαίνει λόγω της ισχυρής σχέσης μεταξύ της τελευταίας και προτελευταίας τιμής της συνάρτησης. Περιέργως οι μερικές αυτοσυσχετίσεις παρουσιάζουν στατιστικά σημαντικές τιμές για 1 και 12 βήματα καθυστέρησης.

![4](../assets/autocorrelation_AMA1.png "Συνάρτηση αυτοσυσχέτισης")

![5](../assets/partial_autocorrelations_AMA1.png "Συνάρτηση μερικής αυτοσυσχέτισης")

#### Κώδικας για τον υπολογισμό των αυτοσυσχετίσεων
```matlab
if(AUTOCORR_PLOT)
  autrocor_plot(yV, name);
  portmanteauLB(yV, 20, 0.05, name);
end
```
```matlab
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
Από τα παραπάνω καταλαβαίνουμε ότι αν χρησιμοποιήσουμε AR ή ARMA διαδικασίες για να εξηγήσουμε την συμπεριφορά της χρονοσειράς θα πρέπει το AR μέρος να έχει μέγιστο βαθμό περίπου 12. Προκειμένου να διαλέξουμε το κατάλληλο μοντέλο χρειάζεται πρώτα να πειραματιστούμε με έναν αριθμό υποψήφιων μοντέλων. Εφόσον αφαιρέσαμε την τάση και δεν βλέπουμε κάποιο άλλο είδος τάσης στις χρονοσειρές γνωρίζουμε ότι δεν έχει νόημα να χρησιμοποιήσουμε μοντέλα τύπου ARIMA με $I \neq 0$. Τώρα έχουμε διαλέξει τον χώρο αναζήτησης του βέλτιστου γραμμικού μοντέλου, το μόνο που χρειαζόμαστε ακόμα είναι το τελικό κριτήριο για την επιλογή του. Το τελικό κριτήριο επιλογής είναι το κριτήριο πληροφορίας Akaike με βάση το σφάλμα NRMSE. Στα διαγράμματα [6],[7],[8] δείχνουμε τα κριτήρια αυτά για τα υποψήφια μοντέλα. Επίσης παρακάτω δίνουμε και το κομμάτι του κώδικα το οποίο δημιοργεί τα κριτήρια αυτά.


AIC για τα υποψήφια AR μοντέλα | AIC για τα υποψήφια MA μοντέλα
:-------------------------:|:-------------------------:
![6](../assets/MA_AIC_AMA1_T_1.png "AIC για τα υποψήφια AR μοντέλα")  |  ![7](../assets/AR_AIC_AMA1_T_1.png "AIC για τα υποψήφια MA μοντέλα") 
---
![8](../assets/ARMA_AIC_AMA1_T_1.png "AIC για τα υποψήφια ARMA μοντέλα")

#### Κώδικας για τα AR μοντέλα
```matlab
function ar_estimate(yV, name, T, MAX_ORDER_AR)
  NRMSE = zeros(MAX_ORDER_AR,1);
  A = zeros(MAX_ORDER_AR,1);
  for i = 1: 1: MAX_ORDER_AR
    [n, ~, ~, ~, A(i), ~, ~] = fitARMA(yV, i, 0, T);
    NRMSE(i) = n(end);
  end
  f = figure;
  plot(NRMSE);
  grid on;
  s = sprintf('NRMSE of %s for AR process T=%d',  name, T);
  title(s);
  saveas(f, sprintf('assets/AR_NRMSE_%s_T_%d.%s',name,T,'png'));
  
  f = figure;
  plot(A);
  grid on;
  s = sprintf('Akaike criterion of %s for AR process T=%d',  name, T);
  title(s);
  saveas(f, sprintf('assets/AR_AIC_%s_T_%d.%s',name,T,'png'));
end
```

#### Κώδικας για τα ΜΑ μοντέλα
```matlab 
function ma_estimate(yV, name, T, MAX_ORDER_MA)
  NRMSE = zeros(1, MAX_ORDER_MA);
  A = zeros(1, MAX_ORDER_MA);
  for j = 1: 1: MAX_ORDER_MA
    [n, ~, ~, ~, A(j), ~, ~] = fitARMA(yV, 0, j, T);
    NRMSE(j) = n(end);
  end
  f = figure;
  plot(NRMSE);
  grid on;
  s = sprintf('NRMSE of %s for MA process T=%d', name, T);
  title(s);
  saveas(f, sprintf('assets/MA_NRMSE_%s_T_%d.%s',name,T,'png'));
  
  f = figure;
  plot(A);
  grid on;
  s = sprintf('Akaike criterion of %s for MA process T=%d', name, T);
  title(s);
  saveas(f, sprintf('assets/MA_AIC_%s_T_%d.%s',name,T,'png'));
end
```

#### Κώδικας για τα ARMA μοντέλα
```matlab
function arma_estimate(yV, name, T, MAX_ORDER_AR, MAX_ORDER_MA)
  NRMSE = zeros(MAX_ORDER_AR, MAX_ORDER_MA);
  A = zeros(MAX_ORDER_AR, MAX_ORDER_MA);
  for i = 1: 1 : MAX_ORDER_AR
    for j = 1: 1 : MAX_ORDER_MA
      [n, ~, ~, ~, A(i,j), ~, ~] = fitARMA(yV, i, j, T);
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
  s = sprintf('NRMSE of %s for ARMA process T=%d', name, T);
  title(s);
  saveas(f, sprintf('assets/ARMA_NRMSE_%s_T_%d.%s',name,T,'png'));
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
  s = sprintf('Akaike criterion of %s for ARMA process T=%d', name, T);
  title(s);
  saveas(f, sprintf('assets/ARMA_AIC_%s_T_%d.%s',name,T,'png'));
end
```

Από τα σχήματα του AIC για τα υποψήφια μοντέλα, παρατηρούμε ότι το μοντέλο `ARMA(13,5)` παρουσιάζει τη μικρότερη τιμή του AIC. Αυτό σημαίνει ότι θα διαλέξουμε το μοντέλο `ARMA(13,5)` για να εξηγήσουμε τη συμπεριφορά αυτής της χρονοσειράς. Τέλος για αυτό το μοντέλο δίνουμε το διάγραμμα που παρουσιάζει κατά πόσο μπορεί να προβλέψει μελοντικές τιμές της εισόδου.

![9](../assets/ARMA_best_pred_AMA1.png "Προβλέψεις τιμών για το καλύτερο μοντέλο")

Από τα σφάλματα NRMSE βλέπουμε ότι οι προβλέψεις είναι κακές τόσο για βήμα T=1 όσο και για T=2. Για αυτό και η πρόβλεψη με χρήση της μέσης τιμής δίνει καλύτερα αποτελέσματα.
#### TMI
Παρακάτω πραγματοποιούμε τα ίδια βήματα για τη χρονοσειρά `TMI`. Επειδή ο κώδικας είναι γραμμένος όλος σε συναρτήσεις σύμφωνα με τα πρότυπα του δομημένου προγραμματισμού, το μόνο που θα έπρεπε να αλλάξουμε είναι οι παραμέτροι με τους οποίους μελετάμε τη χρονοσειρά. Πρακτικά για να γίνει η γραμμική ανάλυση της χρονοσειράς `TMI` καλούμε:
```matlab
linear_analysis(TMI, 'TMI1', MAX_ORDER_AR, MAX_ORDER_MA, POLORDER, ...
                EXTREMA_PLOT, EXTREMA_SERIES_PLOT, REMOVES_TREND, ...
                REMOVES_TREND_PLOT, AUTOCORR_PLOT, AKAIKE, DST_NUM);
```
Επίσης αλλάζουμε τις τιμές στις μεταβλητές `MAX_ORDER_AR`, `MAX_ORDER_MA` στο αρχείο `main.m` ως εξής:
```matlab
MAX_ORDER_AR    = 30;
MAX_ORDER_MA    = 5;
```

Τα διαγράμματα που προκύπτουν είναι τα εξής:

![]("")

![]("")

![]("")

![]("")

![]("")

