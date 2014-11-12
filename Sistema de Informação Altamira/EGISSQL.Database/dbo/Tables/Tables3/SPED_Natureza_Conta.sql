CREATE TABLE [dbo].[SPED_Natureza_Conta] (
    [cd_natureza_conta] INT          NOT NULL,
    [nm_natureza_conta] VARCHAR (60) NULL,
    [sg_natureza_conta] CHAR (10)    NULL,
    [cd_usuario]        INT          NULL,
    [dt_usuario]        DATETIME     NULL,
    CONSTRAINT [PK_SPED_Natureza_Conta] PRIMARY KEY CLUSTERED ([cd_natureza_conta] ASC)
);

