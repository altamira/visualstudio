CREATE TABLE [dbo].[APC_Tipo_Ajuste] (
    [cd_tipo_ajuste]  INT          NOT NULL,
    [nm_tipo_ajuste]  VARCHAR (60) NULL,
    [cd_usuario]      INT          NULL,
    [dt_usuario]      DATETIME     NULL,
    [ic_conta_ajuste] CHAR (1)     NULL,
    CONSTRAINT [PK_APC_Tipo_Ajuste] PRIMARY KEY CLUSTERED ([cd_tipo_ajuste] ASC)
);

