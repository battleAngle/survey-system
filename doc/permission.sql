INSERT INTO `t_role` ( `id`, `create_perm`, `deploy_perm`, `export_perm`, `import_perm`,
                                 `pause_perm`, `remove_perm`, `role_id`, `tpl_export_perm`,
                                 `update_perm`, `view_perm` )
VALUES
( '1', 1, 1, 1, 1, 1, 1, 0, 1, 1, 1 ),
( '2', 1, 1, 1, 1, 1, 1, 1, 1, 1, 1 ),
( '3', 1, 1, 1, 1, 1, 0, 2, 1, 1, 1 ),
( '4', 1, 1, 1, 1, 0, 0, 3, 1, 1, 1 ),
( '5', 1, 0, 0, 1, 0, 0, 4, 0, 1, 1 ),
( '6', 0, 0, 0, 1, 0, 0, 5, 0, 0, 1 );