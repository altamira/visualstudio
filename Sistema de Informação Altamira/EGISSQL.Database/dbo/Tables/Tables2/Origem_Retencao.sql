CREATE TABLE [dbo].[Origem_Retencao] (
    [cd_origem_retencao]     INT          NOT NULL,
    [nm_origem_retencao]     VARCHAR (30) NULL,
    [sg_origem_retencao]     CHAR (10)    NULL,
    [cd_usuario]             INT          NULL,
    [dt_usuario]             DATETIME     NULL,
    [cd_ordem_producao]      INT          NULL,
    [ic_pad_origem_retencao] CHAR (1)     NULL,
    CONSTRAINT [PK_Origem_Retencao] PRIMARY KEY CLUSTERED ([cd_origem_retencao] ASC) WITH (FILLFACTOR = 90)
);

