*"* use this source file for the definition and implementation of
*"* local helper classes, interface definitions and type
*"* declarations
*"* use this source file for the definition and implementation of
*"* local helper classes, interface definitions and type
*"* declarations

CLASS lcl_copy_data DEFINITION.

  PUBLIC SECTION.

    METHODS constructor
      IMPORTING
        i_target_table TYPE tabname
      RAISING
        cx_abap_not_a_table
      .

    METHODS
      copy_data.


  PROTECTED SECTION.
  PRIVATE SECTION.
    DATA flights    TYPE STANDARD TABLE OF /lrn/s4d400_apt WITH NON-UNIQUE DEFAULT KEY.

    DATA table_name TYPE tabname.

    DATA user       TYPE abp_creation_user VALUE 'GENERATOR'.
    DATA timestamp  TYPE abp_creation_tstmpl.

    METHODS prepare_data.

    METHODS is_empty_db
      RETURNING VALUE(result) TYPE abap_bool.

    METHODS delete_db.

    METHODS insert_db.

    METHODS matches_template
      RETURNING VALUE(result) TYPE abap_bool.

    CONSTANTS template_table TYPE tabname VALUE '/LRN/S4D400_APT'.
    CONSTANTS source_table   TYPE tabname VALUE '/DMO/FLIGHT'.

    ENDCLASS.

CLASS lcl_copy_data IMPLEMENTATION.

  METHOD constructor.

* Store table name
    me->table_name = i_target_table.

    IF me->matches_template( ) <> abap_true.
      RAISE EXCEPTION TYPE cx_abap_not_a_table.
    ENDIF.

  ENDMETHOD.

METHOD copy_data.

  prepare_data( ).

* If DB table is NOT empty, delete old records first
  IF me->is_empty_db( ) = abap_true.
    me->delete_db( ).
  ENDIF.

  me->insert_db( ).

ENDMETHOD.

  METHOD is_empty_db.
    CLEAR result.

    SELECT SINGLE
      FROM (table_name)
    FIELDS @abap_true
     INTO @result.

  ENDMETHOD.

  METHOD delete_db.
    DELETE FROM (table_name).
  ENDMETHOD.

  METHOD insert_db.

    INSERT (table_name) FROM TABLE @flights.

  ENDMETHOD.

  METHOD prepare_data.

* Fill with data from source
    SELECT FROM (source_table)
      FIELDS *
      INTO CORRESPONDING FIELDS OF TABLE @flights.

    GET TIME STAMP FIELD me->timestamp. "Get timestamp

    LOOP AT me->flights ASSIGNING FIELD-SYMBOL(<flight>).

      <flight>-local_created_by  = user.
      <flight>-local_created_at = timestamp.
      <flight>-local_last_changed_by = user.
      <flight>-local_last_changed_at = timestamp.
      <flight>-last_changed_at = timestamp.

    ENDLOOP.

  ENDMETHOD.

  METHOD matches_template.

    result = abap_true.

    cl_abap_typedescr=>describe_by_name(
                       EXPORTING
                        p_name = table_name
                        RECEIVING
                         p_descr_ref = DATA(typedescr)
                       EXCEPTIONS
                        type_not_found = 1 ).

    IF sy-subrc <> 0.
      result = abap_false.
      RETURN.
    ENDIF.                    .

    IF typedescr->kind <> cl_abap_typedescr=>kind_struct OR
       typedescr->is_ddic_type( ) <> cl_abap_typedescr=>true.
      result = abap_false.
      RETURN.
    ENDIF.

    IF CAST cl_abap_structdescr( typedescr )->components <>
       CAST cl_abap_structdescr( cl_abap_typedescr=>describe_by_name( template_table )
                               )->components.
      result = abap_false.
      RETURN.
    ENDIF.

  ENDMETHOD.

ENDCLASS.

