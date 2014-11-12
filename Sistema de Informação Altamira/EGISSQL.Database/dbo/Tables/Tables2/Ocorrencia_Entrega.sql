CREATE TABLE [dbo].[Ocorrencia_Entrega] (
    [cd_ocorrencia_entrega]  INT          NOT NULL,
    [nm_ocorrencia_entrega]  VARCHAR (40) NULL,
    [sg_ocorrencia_entrega]  CHAR (10)    NULL,
    [cd_usuario]             INT          NULL,
    [dt_usuario]             DATETIME     NULL,
    [ic_estoque_ocorrencia]  CHAR (1)     NULL,
    [ic_comissao_ocorrencia] CHAR (1)     NULL,
    [ic_receber_ocorrencia]  CHAR (1)     NULL,
    CONSTRAINT [PK_Ocorrencia_Entrega] PRIMARY KEY CLUSTERED ([cd_ocorrencia_entrega] ASC) WITH (FILLFACTOR = 90)
);

