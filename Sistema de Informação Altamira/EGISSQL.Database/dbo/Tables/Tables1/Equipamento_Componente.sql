CREATE TABLE [dbo].[Equipamento_Componente] (
    [cd_equipamento]            INT          NOT NULL,
    [cd_equipamento_componente] INT          NOT NULL,
    [cd_tipo_componente]        INT          NULL,
    [cd_produto]                INT          NULL,
    [nm_equipamento_componente] VARCHAR (40) NULL,
    [nm_obs_equipto_componente] VARCHAR (40) NULL,
    [dt_prev_manut_componente]  DATETIME     NULL,
    [dt_manut_componente]       DATETIME     NULL,
    [cd_usuario]                INT          NULL,
    [dt_usuario]                DATETIME     NULL,
    CONSTRAINT [PK_Equipamento_Componente] PRIMARY KEY CLUSTERED ([cd_equipamento] ASC, [cd_equipamento_componente] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Equipamento_Componente_Produto] FOREIGN KEY ([cd_produto]) REFERENCES [dbo].[Produto] ([cd_produto])
);

