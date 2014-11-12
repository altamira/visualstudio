CREATE TABLE [dbo].[Orcmot] (
    [mot_descricao] NVARCHAR (40) NULL,
    [st_codigo]     INT           NULL,
    [idOrcMot]      INT           IDENTITY (1, 1) NOT NULL,
    CONSTRAINT [PK_Orcmot] PRIMARY KEY CLUSTERED ([idOrcMot] ASC)
);

