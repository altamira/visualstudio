CREATE TABLE [dbo].[Siscomex_Adicao] (
    [cd_siscomex_adicao] INT          NOT NULL,
    [nm_siscomex_adicao] VARCHAR (40) NULL,
    [qt_adicao_siscomex] INT          NULL,
    [vl_adicao_siscomex] FLOAT (53)   NULL,
    [cd_usuario]         INT          NULL,
    [dt_usuario]         DATETIME     NULL,
    [cd_moeda]           INT          NULL,
    CONSTRAINT [PK_Siscomex_Adicao] PRIMARY KEY CLUSTERED ([cd_siscomex_adicao] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Siscomex_Adicao_Moeda] FOREIGN KEY ([cd_moeda]) REFERENCES [dbo].[Moeda] ([cd_moeda])
);

