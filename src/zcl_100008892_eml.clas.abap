CLASS zcl_100008892_eml DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC.

  PUBLIC SECTION.
    INTERFACES if_oo_adt_classrun.

ENDCLASS.


CLASS zcl_100008892_eml IMPLEMENTATION.

  METHOD if_oo_adt_classrun~main.

    DATA agencies_upd TYPE TABLE FOR UPDATE /dmo/i_agencytp.

    agencies_upd = VALUE #(
      (
        AgencyID = '070777'
        Name     = 'Sharath Travel Agency'
      )
    ).

    MODIFY ENTITIES OF /dmo/i_agencytp
      ENTITY /dmo/agency
      UPDATE FIELDS ( Name )
      WITH agencies_upd.

    COMMIT ENTITIES.

    out->write( `EML update completed.` ).

  ENDMETHOD.

ENDCLASS.
