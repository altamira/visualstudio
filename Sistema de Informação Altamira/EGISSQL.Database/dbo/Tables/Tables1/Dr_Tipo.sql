CREATE TABLE [dbo].[Dr_Tipo] (
    [cd_dr_tipo]       INT          NOT NULL,
    [nm_dr_tipo]       VARCHAR (40) NULL,
    [sg_dr_tipo]       CHAR (10)    NULL,
    [cd_usuario]       INT          NULL,
    [dt_usuario]       DATETIME     NULL,
    [ic_ativo_dr_tipo] CHAR (1)     NULL,
    [ic_pad_dr_tipo]   CHAR (1)     NULL,
    CONSTRAINT [PK_Dr_Tipo] PRIMARY KEY CLUSTERED ([cd_dr_tipo] ASC) WITH (FILLFACTOR = 90)
);

