CREATE TABLE [dbo].[SPED_Fiscal_Perfil] (
    [cd_perfil]  INT          NOT NULL,
    [nm_perfil]  VARCHAR (40) NULL,
    [sg_perfil]  CHAR (10)    NULL,
    [cd_usuario] INT          NULL,
    [dt_usuario] DATETIME     NULL,
    CONSTRAINT [PK_SPED_Fiscal_Perfil] PRIMARY KEY CLUSTERED ([cd_perfil] ASC) WITH (FILLFACTOR = 90)
);

