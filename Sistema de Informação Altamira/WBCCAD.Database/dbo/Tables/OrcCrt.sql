CREATE TABLE [dbo].[OrcCrt] (
    [numeroOrcamento]          NCHAR (9)     NULL,
    [orccrt_altura]            MONEY         NULL,
    [orccrt_altura_base]       MONEY         NULL,
    [orccrt_largura]           MONEY         NULL,
    [orccrt_profundidade]      MONEY         NULL,
    [orccrt_cabeceiras]        MONEY         NULL,
    [orccrt_cap_termica]       MONEY         NULL,
    [orccrt_corte]             NVARCHAR (50) NULL,
    [orccrt_decibeis]          MONEY         NULL,
    [orccrt_departamento]      NVARCHAR (50) NULL,
    [orccrt_estrutura]         MONEY         NULL,
    [orccrt_folga]             MONEY         NULL,
    [orccrt_grupo]             INT           NULL,
    [orccrt_hp]                MONEY         NULL,
    [orccrt_largura_cabeceira] MONEY         NULL,
    [orccrt_nr_seq]            NVARCHAR (50) NULL,
    [orccrt_setor]             NVARCHAR (50) NULL,
    [orccrt_subgrupo]          NVARCHAR (2)  NULL,
    [orccrt_tipo_corte]        MONEY         NULL,
    [orccrt_utilizacao]        NVARCHAR (50) NULL,
    [orccrt_valor_total]       MONEY         NULL,
    [orccrt_viz_atras]         NVARCHAR (50) NULL,
    [orccrt_viz_final]         NVARCHAR (50) NULL,
    [orccrt_viz_inicio]        NVARCHAR (50) NULL,
    [idOrcCrt]                 INT           IDENTITY (1, 1) NOT NULL,
    [orccrt_item]              VARCHAR (20)  NULL,
    CONSTRAINT [PK_OrcCrt] PRIMARY KEY CLUSTERED ([idOrcCrt] ASC)
);


GO
CREATE UNIQUE NONCLUSTERED INDEX [IX_OrcCrt]
    ON [dbo].[OrcCrt]([numeroOrcamento] ASC, [idOrcCrt] ASC);

