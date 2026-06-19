function start --description 'Kies een project om de dev server te starten en open de exacte poort'
    set DEV_DIR "$HOME/Development"
    set OUDE_MAP (pwd)

    if not test -d $DEV_DIR
        echo "[-] Fout: De map $DEV_DIR bestaat niet."
        return 1
    end

    # Haal alle projectmappen op
    builtin cd $DEV_DIR
    set projects *

    if test (count $projects) -eq 0
        echo "[-] Geen projecten gevonden in $DEV_DIR."
        builtin cd $OUDE_MAP >/dev/null
        return 1
    end

    echo "========================================================================"
    echo "          🚀 KIES EEN PROJECT OM DE DEV SERVER TE STARTEN"
    echo "========================================================================"
    
    set i 1
    for project in $projects
        if test -d $project
            echo "  [$i] $project"
            set i (math $i + 1)
        end
    end
    echo "========================================================================"

    echo -n "Typ het cijfer van je project (of 'q' om te stoppen): "
    read -l keuze

    if test "$keuze" = "q"
        echo "[+] Geannuleerd."
        builtin cd $OUDE_MAP >/dev/null
        return 0
    end

    if string match -r '^[0-9]+$' -- "$keuze"; and test $keuze -ge 1; and test $keuze -lt $i
        set gekozen_project $projects[$keuze]
        set project_path "$DEV_DIR/$gekozen_project"

        echo ""
        echo "[+] Dev server starten voor $gekozen_project..."

        # --- REVOLUTIONAIRE POORT DETECTIE ---
        # We starten de server in Alacritty, maar schrijven de log tegelijkertijd naar een tijdelijk bestand
        set LOG_FILE (mktemp)
        
        if command -v alacritty >/dev/null
            nohup alacritty --working-directory $project_path -e fish -c "npm run dev | tee $LOG_FILE; or echo '[-] Server gestopt.'; read" >/dev/null 2>&1 &
        else if command -v konsole >/dev/null
            nohup konsole --workdir $project_path -e fish -c "npm run dev | tee $LOG_FILE; or echo '[-] Server gestopt.'; read" >/dev/null 2>&1 &
        end

        # We wachten maximaal 5 seconden tot Vite of Express zijn lokale URL logt
        echo -n "[+] Wachten op server poort..."
        set -l timeout 0
        set -l gedetecteerde_url ""

        while test $timeout -lt 50
            echo -n "."
            sleep 0.1
            set timeout (math $timeout + 1)
            
            # Zoek naar http://localhost:XXXX of http://127.0.0.1:XXXX in de live log
            set gedetecteerde_url (grep -oE "http://(localhost|127\.0\.0\.1|0\.0\.0\.0):[0-9]+" $LOG_FILE | head -n 1)
            
            if test -n "$gedetecteerde_url"
                # Als we een URL vinden (maakt niet uit welke poort), breken we de loop
                break
            end
        end
        echo ""

        # Open de browser op de EXACTE poort die de server zojuist heeft geclaimd
        if test -n "$gedetecteerde_url"
            # Zorg dat eventuele 0.0.0.0 netjes als localhost wordt geopend
            set open_url (string replace -r "0\.0\.0\.0" "localhost" "$gedetecteerde_url")
            echo "[+] Gevonden! Browser openen op $open_url..."
            xdg-open "$open_url" >/dev/null 2>&1
        else
            # Fallback als de poort-scan om wat voor reden dan ook faalt
            echo "[-] Kon poort niet automatisch uitlezen uit terminal log. Probeer handmatig."
            xdg-open "http://localhost:5173" >/dev/null 2>&1
        end

        # Ruim het tijdelijke logbestand netjes op
        rm -f $LOG_FILE

        # Keer terug naar waar je was
        builtin cd $OUDE_MAP >/dev/null
        echo "[+] Succes! Je huidige terminal is weer vrij."
    else
        echo "[-] Ongeldige keuze."
        builtin cd $OUDE_MAP >/dev/null
        return 1
    end
end