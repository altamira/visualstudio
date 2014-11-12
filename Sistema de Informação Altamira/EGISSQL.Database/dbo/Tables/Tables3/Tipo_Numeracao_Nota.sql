CREATE TABLE [dbo].[Tipo_Numeracao_Nota] (
    [cd_tipo_numeracao_nota] INT          NOT NULL,
    [nm_tipo_numeracao_nota] VARCHAR (30) NULL,
    [sg_tipo_numeracao_nota] CHAR (10)    NULL,
    [ic_tipo_numeracao_nota] CHAR (1)     NULL,
    [cd_usuario]             INT          NULL,
    [dt_usuario]             DATETIME     NULL,
    CONSTRAINT [PK_Tipo_Numeracao_Nota] PRIMARY KEY CLUSTERED ([cd_tipo_numeracao_nota] ASC) WITH (FILLFACTOR = 90)
);

