;
; $dvidef
;
(progn
    (~sys_literal_setup_incr "dvi$_" 2 2
            "devchar"
            "devclass"
            "devtype"
            "devbufsiz"
            "devdepend"
            "unit"
            "pid"
            "ownuic"
            "vprot"
            "errcnt"
            "opcnt"
            "recsiz"
            "maxblock"
            "devdepend2"
            "refcnt"
            "devnam"
            "volnam"
            "sectors"
            "tracks"
            "cylinders"
            "freeblocks"
            "logvolnam"
            "volnumber"
            "volcount"
            "rootdevnam"
            "nextdevnam"
            "transcnt"
            "mountcnt"
            "cluster"
            "maxfiles"
            "serialnum"
            "acppid"
            "acptype"
            "concealed"



            "rec"
            "ccl"
            "trm"
            "dir"
            "sdi"
            "sqd"
            "spl"
            "opr"
            "rct"
            "net"
            "fod"
            "dua"
            "shr"
            "gen"
            "avl"
            "mnt"
            "mbx"
            "dmt"
            "elg"
            "all"
            "for"
            "swl"
            "idv"
            "odv"
            "rnd"
            "rtm"
            "rck"
            "wck"




            "tt_passall"
            "tt_noecho"
            "tt_notypeahd"
            "tt_escape"
            "tt_hostsync"
            "tt_ttsync"
            "tt_script"
            "tt_lower"
            "tt_mechtab"
            "tt_wrap"
            "tt_crfill"
            "tt_lffill"
            "tt_scope"
            "tt_remote"
            "tt_eightbit"
            "tt_mbxdsabl"
            "tt_nobrdcst"
            "tt_readsync"
            "tt_mechform"
            "tt_halfdup"
            "tt_modem"
            "tt_oper"
            "tt_page"



            "tt_localecho"
            "tt_autobaud"
            "tt_hangup"
            "tt_modhangup"
            "tt_brdcstmbx"
            "tt_dma"
            "tt_altypeahd"
            "tt_setspeed"
            "tt_dcl_mailbx"
            "tt_editing"
            "tt_insert"
            "tt_fallback"
            "tt_dialup"
            "tt_secure"
            "tt_disconnect"
            "tt_pasthru"
            "tt_sixel"
            "tt_drcs"
            "tt_printer"
            "tt_app_keypad"
            "tt_syspwd"
            "tt_ansicrt"
            "tt_regis"
            "tt_block"
            "tt_avo"
            "tt_edit"
            "tt_deccrt"


            "sts"
            "devsts"
            "devchar2"
            "fulldevnam"
            "lockid"
            "alldevnam"
            "volsetmem"
            "devlocknam"



            "alloclass"
            "alt_host_avail"
            "alt_host_name"
            "alt_host_type"
            "host_avail"
            "host_count"
            "host_name"
            "host_type"
            "remote_device"
            "served_device"
            "shdw_catchup_copying"
            "shdw_master"
            "shdw_master_name"
            "shdw_member"
            "shdw_merge_copying"
            "shdw_next_mbr_name"



            "tt_phydevnam"
            "tt_deccrt2"

            "media_name"
            "media_type"
            "media_id"



            "shdw_failed_member"
    )
    (~sys_literal_setup_equal "dvi$"
        "m_secondary"   1
        "m_noredirect"  32768
    )
    (~sys_literal_setup_incr "dvi$c_" 1 1
        "acp_f11v1"
        "acp_f11v2"
        "acp_mta"
        "acp_net"
        "acp_rem"
    )
)
