CREATE TABLE [dbo].[varusr] (
    [idVarusr]        INT             IDENTITY (1, 1) NOT NULL,
    [varusrcodigo]    NVARCHAR (50)   NULL,
    [varusrdescricao] NVARCHAR (1024) NULL,
    [varusrtipo]      INT             NULL,
    [varusrgrupo]     NVARCHAR (50)   NULL,
    [VARUSRVALOR]     MONEY           NULL,
    [VARUSRPADRAO]    NVARCHAR (255)  NULL,
    [VarUsrLista]     NVARCHAR (500)  NULL,
    CONSTRAINT [PK_varusr] PRIMARY KEY CLUSTERED ([idVarusr] ASC)
);


GO
CREATE NONCLUSTERED INDEX [IX_varusr]
    ON [dbo].[varusr]([varusrcodigo] ASC);

