CREATE TABLE [dbo].[Dica_Modulo] (
    [cd_dica]       INT          NOT NULL,
    [nm_dica]       VARCHAR (40) NULL,
    [ds_dica]       TEXT         NULL,
    [ic_ativa_dica] CHAR (1)     NULL,
    [cd_modulo]     INT          NULL,
    [cd_usuario]    INT          NULL,
    [dt_usuario]    DATETIME     NULL,
    CONSTRAINT [PK_Dica_Modulo] PRIMARY KEY CLUSTERED ([cd_dica] ASC) WITH (FILLFACTOR = 90)
);

