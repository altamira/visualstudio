CREATE TABLE [dbo].[APC_Tipo_Conta] (
    [cd_tipo_conta] INT          NOT NULL,
    [nm_tipo_conta] VARCHAR (40) NULL,
    [sg_tipo_conta] CHAR (10)    NULL,
    [cd_usuario]    INT          NULL,
    [dt_usuario]    DATETIME     NULL,
    CONSTRAINT [PK_APC_Tipo_Conta] PRIMARY KEY CLUSTERED ([cd_tipo_conta] ASC)
);

