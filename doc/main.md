---
output: 
  pdf_document:
    pdf_engine: xelatex
    template: ~/projects/svm-r-markdown-templates/svm-latex-ms.tex
title: "Υπολογιστική Εργασία στις Χρονοσειρές"
thanks: "Υπολογιστική Εργασία στις Χρονοσειρές THMMY ΑΠΘ. "
author: 
  - "Ιωάννης Αθανασιάδης 7848"
  - "Σπυρίδων Αντωνιάδης 8030"
lang: gr
abstract: "αδασδασδασδ"
keywords: "pandoc, r markdown, knitr"
date: "10/2/2018"
geometry: margin=1in
fontfamily: mathpazo
fontsize: 11pt
biblio-style: apsr
endnote: no
header-includes:
  \renewcommand{\abstractname}{Εισαγωγή}
---
Η παρούσα εργασία αφορά χρονοσειρές πό την κίνηση του ματιού που μετρήθηκαν στο Εργαστήριο του Department of Otolaryngology/Head \& Neck Surgery, Haukeland University Hospital, Bergen, Νορβηγία. Το πείραμα αυτό γίνεται για τη διάγνωση ιλίγγου (έλλειψη ισορροπίας στο λαβύρινθο του αυτιού). Παρακάτω εξετάζονται δύο χρονοσειρές. Η κάθε χρονοσειρά αφορά ένα τέτοιο πείραμα για ίδια φορά και ταχύτητα αλλά για διαφορετική κατηγορία ατόμου (υγιής / ασθενής). Κατά το πείραμα το μάτι ακολουθεί ανεπαίσθητα τις λωρίδες και επανέρχεται δημιουργώντας σήμα με συνεχόμενους σχηματισμούς, που αποτελούνται από ανοδική αργή τάση (καθώς 
το μάτι ξεγελιέται και ακολουθεί τις λωρίδες) και απότομη πτώση (στο σημείο που επανέρχεται το μάτι). Η κίνηση αυτή του ματιού λέγεται οπτοκινητικός νυσταγμός 
(optokinetic nystagmus, OKN)

## Γραμμική ανάλυση 1ης χρονοσειράς
Η πρώτη χρονοσειρά που μας δίνεται όπως φαίνεται από το διαγραμμά της,
δε φαίνεται να κρύβει κάποια τάση π.χ. ανοδική. Οπότε, μάλλον ο ασθενής είναι υγιής (αυτό θα φανεί και αργότερα, αλλά χωρίς επαρκή ανάλυση δεν θα μπορούσαμε να υποστηρίξουμε κάτι τέτοιο). Επίσης, δε φαίνεται να είναι μόνο θόρυβος. Από αυτά εκτιμάμε ότι η χρονοσειρά εμπεριέχει πληροφορία για τον ασθενή. Στο Σχήμα [1]: φαίνονται σε χρονική σειρά οι 6000 τιμές του σήματος που λάβαμε από το πρώτο πείραμα.
![Ή πρώτη χρονοσειρά](../assets/basic_plot_1st.png "Χρονοσειρά 1")


Μπορούμε να δούμε ότι από το βήμα 1000 μέχρι περίπου το βήμα 1200 το μάτι ξεγιελιέται αρκετά, ενώ λίγο μετά επανέρχεται. Για τις άλλες χρονικές στιγμές δε θα μπορούσαμε να πούμε κάτι ξεκάθαρο. Για αυτό και θα προχωρήσουμε στην ανάλυση του πειράματος με τα εργαλεία που έχουμε διδαχθεί στο μάθημα. Αρχικά θα πρέπει να παρουσιάσουμε.

### Εξαγωγή χρονοσειράς μελέτης
Με βάση τη συνάρτηση `extremes.m` που μας δόθηκε εξάγαμε όλες τις χρονοσειρές για τα τοπικά ακρότατα και τους χρόνους τους. Εκτός από τις δοκιμές για τις διάφορες παραμέτρους αυτής της συνάρτησης υλοποιήσαμε και δικά μας εργαλεία για να δούμε πρακτικά κατά πόσο η έξοδος της `extremes.m` είναι αποδεκτή. Πρώτα επειδή γνωρίζουμε ότι γίνεται χρήση ενός FIR φίλτρου και πάνω στην έξοδό του γίνεται η εύρεση των ακροτάτων θελήσαμε να εξετάσουμε την τάξη του φίλτρου. Για αυτό δοκιμάσαμε διάφορες τιμές από 5 έως 30 με βήμα 5 και καταλήξαμε ότι η τάξη 10 είναι αρκετά πιο υποσχόμενη.

`Κώδικας ελέγχου τάξης φίλτρου`:
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

`Κώδικας εξαγωγής και ελέγχου του πίνακα ακροτάτων`:
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

` Κώδικας εξαγωγής των ζητούμενων χρονοσειρών, από την έξοδο της extremes.m`
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


# Γραμμική ανάλυση 2ης χρονοσειράς