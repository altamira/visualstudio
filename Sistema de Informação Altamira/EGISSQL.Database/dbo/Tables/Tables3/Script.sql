CREATE TABLE [dbo].[Script] (
    [cd_script]        INT          NOT NULL,
    [nm_script]        VARCHAR (40) NULL,
    [sg_script]        CHAR (10)    NULL,
    [ic_padrao_script] CHAR (1)     NULL,
    [ic_ativo_script]  CHAR (1)     NULL,
    [nm_obs_script]    VARCHAR (40) NULL,
    [cd_usuario]       INT          NULL,
    [dt_usuario]       DATETIME     NULL,
    CONSTRAINT [PK_Script] PRIMARY KEY CLUSTERED ([cd_script] ASC) WITH (FILLFACTOR = 90)
);

