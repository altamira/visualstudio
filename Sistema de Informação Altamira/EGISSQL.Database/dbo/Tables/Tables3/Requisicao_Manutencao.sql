CREATE TABLE [dbo].[Requisicao_Manutencao] (
    [cd_requisicao_manutencao]  INT          NOT NULL,
    [dt_requisicao_manutencao]  DATETIME     NULL,
    [dt_necessidade_manutencao] DATETIME     NULL,
    [cd_departamento]           INT          NULL,
    [cd_usuario_manutencao]     INT          NULL,
    [ds_requisicao_manutencao]  TEXT         NULL,
    [cd_planta]                 INT          NULL,
    [dt_manutencao]             DATETIME     NULL,
    [nm_obs_req_manutencao]     VARCHAR (40) NULL,
    [cd_status_req_manutencao]  INT          NULL,
    [cd_usuario]                INT          NULL,
    [dt_usuario]                DATETIME     NULL,
    CONSTRAINT [PK_Requisicao_Manutencao] PRIMARY KEY CLUSTERED ([cd_requisicao_manutencao] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Requisicao_Manutencao_Status_Req_Manutencao] FOREIGN KEY ([cd_status_req_manutencao]) REFERENCES [dbo].[Status_Req_Manutencao] ([cd_status_req_manutencao])
);

