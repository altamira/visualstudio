CREATE TABLE [dbo].[Tipo_Check_List] (
    [cd_tipo_check_list]       INT          NOT NULL,
    [nm_tipo_check_list]       VARCHAR (40) NULL,
    [sg_tipo_check_list]       CHAR (10)    NULL,
    [ic_ativo_tipo_check_list] CHAR (1)     NULL,
    [cd_usuario]               INT          NULL,
    [dt_usuario]               DATETIME     NULL,
    [ds_obs_tipo_check_list]   TEXT         NULL,
    CONSTRAINT [PK_Tipo_Check_List] PRIMARY KEY CLUSTERED ([cd_tipo_check_list] ASC) WITH (FILLFACTOR = 90)
);

