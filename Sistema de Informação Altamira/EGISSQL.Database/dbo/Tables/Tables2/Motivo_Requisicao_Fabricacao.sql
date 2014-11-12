CREATE TABLE [dbo].[Motivo_Requisicao_Fabricacao] (
    [cd_motivo_requisicao]        INT          NOT NULL,
    [nm_motivo_requisicao]        VARCHAR (40) NULL,
    [sg_motivo_requisicao]        CHAR (10)    NULL,
    [ic_padrao_motivo_requisicao] CHAR (1)     NULL,
    [cd_usuario]                  INT          NULL,
    [dt_usuario]                  DATETIME     NULL,
    CONSTRAINT [PK_Motivo_Requisicao_Fabricacao] PRIMARY KEY CLUSTERED ([cd_motivo_requisicao] ASC) WITH (FILLFACTOR = 90)
);

