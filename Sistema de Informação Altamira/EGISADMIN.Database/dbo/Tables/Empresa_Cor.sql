CREATE TABLE [dbo].[Empresa_Cor] (
    [cd_cor_empresa]       INT          NOT NULL,
    [nm_cor_empresa]       VARCHAR (30) NOT NULL,
    [sg_cor_empresa]       CHAR (10)    NOT NULL,
    [nm_hexa_cor_empresa]  VARCHAR (9)  NOT NULL,
    [ic_ativa_cor_empresa] CHAR (1)     NOT NULL,
    [cd_usuario]           INT          NOT NULL,
    [dt_usuario]           DATETIME     NOT NULL,
    CONSTRAINT [PK_Empresa_Cor] PRIMARY KEY CLUSTERED ([cd_cor_empresa] ASC) WITH (FILLFACTOR = 90)
);

