CREATE TABLE [dbo].[Script_Componente] (
    [cd_script_componente]     INT           NOT NULL,
    [nm_script_componente]     VARCHAR (40)  NULL,
    [sg_script_componente]     CHAR (10)     NULL,
    [ic_tipo_script]           CHAR (1)      NULL,
    [ds_script_componente]     TEXT          NULL,
    [nm_obs_script_componente] VARCHAR (40)  NULL,
    [cd_usuario]               INT           NULL,
    [dt_usuario]               DATETIME      NULL,
    [nm_documento_script]      VARCHAR (100) NULL,
    CONSTRAINT [PK_Script_Componente] PRIMARY KEY CLUSTERED ([cd_script_componente] ASC) WITH (FILLFACTOR = 90)
);

