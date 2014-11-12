CREATE TABLE [dbo].[Status_Ordem_Servico] (
    [cd_status_ordem_servico]  INT          NOT NULL,
    [nm_status_ordem_servico]  VARCHAR (40) NULL,
    [sg_status_ordem_servico]  CHAR (10)    NULL,
    [ic_pad_status_ordem_serv] CHAR (1)     NULL,
    [cd_usuario]               INT          NULL,
    [dt_usuario]               DATETIME     NULL,
    CONSTRAINT [PK_Status_Ordem_Servico] PRIMARY KEY CLUSTERED ([cd_status_ordem_servico] ASC) WITH (FILLFACTOR = 90)
);

