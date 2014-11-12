CREATE TABLE [dbo].[Revisao_Iso] (
    [cd_processo_iso]          INT          NOT NULL,
    [cd_revisao]               INT          NOT NULL,
    [dt_revisao]               DATETIME     NOT NULL,
    [nm_revisao]               VARCHAR (40) NOT NULL,
    [ds_revisao]               TEXT         NOT NULL,
    [cd_usuario]               INT          NOT NULL,
    [dt_usuario]               DATETIME     NOT NULL,
    [cd_empresa]               INT          NOT NULL,
    [dt_aprovacao_revisao_iso] DATETIME     NOT NULL,
    [cd_usuario_aprovacao]     INT          NULL,
    CONSTRAINT [PK_Revisao_Iso] PRIMARY KEY CLUSTERED ([cd_processo_iso] ASC, [cd_revisao] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Revisao_Iso_Empresa] FOREIGN KEY ([cd_empresa]) REFERENCES [dbo].[Empresa] ([cd_empresa])
);

