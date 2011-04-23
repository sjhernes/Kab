using Gtk;
using GLib;

namespace Kabinett {
    
    public class Bar{
               
        /* Diverse informasjon som kan være kos */
        public double antall;
        public double veksel; 
        public double overskudd;
        public double solgte_pils = 0;
        public double solgte_eplekak = 0;
        
        /* Konstruktøren */
        
        public Bar(double ol, double spenn){
            antall = ol;
            veksel = spenn;
        }
    
        /* Salgsfunksjonene */
    
        public void eplesalg(double num){
            veksel += (num * 40);
            overskudd += (num * 12);
            solgte_eplekak++;
        }
        public void salg(double num){
            antall -= num;
            veksel += (num * 20);
            overskudd += (num * 8);
            solgte_pils++;
        }
    }

    /* Home of ugliness, AKA GUI */

    public class GuiStasj : Gtk.Window {
    
        Bar bar;
        
        /* Hva vi selger */
        
        private Button borg;
        private Button eplekak;
        
        /* tallknapper og spinboxen */

        private SpinButton spin_box;
        
        private Button en;
        private Button to;
        private Button tre;
        private Button fire;
        private Button fem;
        
        /* Hvor ting er */
        
        private VBox hovedvindu;
        private HBox hbox;
        private HBox tallknapper;
        private VBox tall;
        private VBox typer;
        
        /* Loggeren <3 */
        
        private TextView log;
        private ScrolledWindow scroll; 
    
        /* Konstruktøren, initierer vinduet og setter knapper der de skal være */
    
        public GuiStasj () {
        
            /* 
             * ja jeg vet det er et kabinett, konstruktøren tar
             * først antall øl, og deretter veksel :)
             */
        
            bar = new Kabinett.Bar(240, 100);
            
            /* 
             * setter tittel, posisjon, aktiverer quit-knapper 
             * og setter default størelse 
             */
            
            this.title = "%d veksel/%d overskudd :: %d øl igjen".printf((int) bar.veksel, (int) bar.overskudd, (int) bar.antall);
            this.position = WindowPosition.CENTER;
            this.destroy.connect (Gtk.main_quit);
            set_default_size (500, 100);
    
            /* Lager knappene for det vi selger */
    
            borg = new Button.with_label("Borg");
            eplekak = new Button.with_label("EpleKAK!");
            
            /* tidenes styggeste tellesystem */
            
            spin_box = new SpinButton.with_range (0, 24, 1);
            en = new Button.with_label("1");
            to = new Button.with_label("2");
            tre = new Button.with_label("3");
            fire = new Button.with_label("4");
            fem = new Button.with_label("5");
            
            /* Loggeren :D med scrollbar */
            
            log = new TextView();
            log.editable = false;
            log.cursor_visible = false;
            scroll = new ScrolledWindow (null, null);
            scroll.set_policy (PolicyType.AUTOMATIC, PolicyType.AUTOMATIC);
            scroll.add (log);
            
            /* Lytterne til knappene */

            // Endrer spinnboxens verdi            
            en.clicked.connect(() => { spin_box.value = 1; });
            to.clicked.connect(() => { spin_box.value = 2; });
            tre.clicked.connect(() => { spin_box.value = 3; });
            fire.clicked.connect(() => { spin_box.value = 4; });
            fem.clicked.connect(() => { spin_box.value = 5; });
            
            // Selger borg og oppdaterer tittelvinduet
            borg.clicked.connect(() => {
                bar.salg(spin_box.value);
                
                this.title = "%d veksel/%d overskudd :: %d øl igjen".printf(
                    (int) bar.veksel, (int) bar.overskudd, (int) bar.antall);
                
                // logger kjøpet
                string s = "%d - øl\n%s".printf((int) spin_box.value, log.buffer.text);
                log.buffer.text = s;
                
                //resetter counteren til 1
                spin_box.value = 1;
            });
            
            // selger eplekake, akkurat som ved borg
            eplekak.clicked.connect(() => {
                bar.eplesalg(spin_box.value);
                this.title = "%d veksel/%d overskudd :: %d øl igjen".printf(
                    (int) bar.veksel, (int) bar.overskudd, (int) bar.antall);
                
                string s = "%d - epleKAK\n%s".printf((int) spin_box.value, log.buffer.text);
                log.buffer.text = s;
                
                spin_box.value = 1;
            });
            
            // starter med at spinboxen viser 1
            spin_box.adjustment.value = 1;
    
    
            // Lager layouten, dårlige navn men 
            hovedvindu = new VBox (true, 5);
            hbox = new HBox (true, 5);
            typer = new VBox (true, 5);
            tallknapper = new HBox (true, 2);
            tall = new VBox (true, 5);
            
            // Legger til nummertastene i en horisontal boks
            tallknapper.add(en);
            tallknapper.add(to);
            tallknapper.add(tre);
            tallknapper.add(fire);
            tallknapper.add(fem);

            // Legger til spinnboksen og knapperekka i en vertikal boks
            tall.add (spin_box);
            tall.add (tallknapper);
            
            // Legger til salgsknappene i en vertikal boks
            typer.add (borg);
            typer.add (eplekak);
            
            // Legger til i en horisontal boks som ligger over logen
            hbox.add (tall);
            hbox.add (typer);
            
            // Legger til log og kontrollen i hovedvinduet
            hovedvindu.add (hbox);
            hovedvindu.add (scroll);
            
            // mæler alt samment i modervinduet
            add (hovedvindu); 
        }
    
        // Starten av programmet.
        public static int main (string[] args) {
            Gtk.init (ref args);
            var window = new GuiStasj ();
            window.show_all ();
            Gtk.main ();
            return 0;
        }
    }
}