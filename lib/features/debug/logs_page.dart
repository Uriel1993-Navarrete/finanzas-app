import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:share_plus/share_plus.dart';
import '../../core/constants/app_colors.dart';
import '../../core/utils/logger.dart';

/// Página para visualizar logs de la aplicación
class LogsPage extends StatefulWidget {
  const LogsPage({super.key});

  @override
  State<LogsPage> createState() => _LogsPageState();
}

class _LogsPageState extends State<LogsPage> {
  LogLevel? _selectedLevel;
  String _searchQuery = '';

  @override
  Widget build(BuildContext context) {
    final logs = AppLogger.getLogs();
    final filteredLogs = logs.where((log) {
      if (_selectedLevel != null && log.level != _selectedLevel) {
        return false;
      }
      if (_searchQuery.isNotEmpty) {
        return log.message.toLowerCase().contains(_searchQuery.toLowerCase()) ||
            (log.tag?.toLowerCase().contains(_searchQuery.toLowerCase()) ?? false);
      }
      return true;
    }).toList().reversed.toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Logs de Depuración'),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_outline),
            onPressed: _clearLogs,
            tooltip: 'Limpiar logs',
          ),
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: () => _exportLogs(context),
            tooltip: 'Exportar logs',
          ),
        ],
      ),
      body: Column(
        children: [
          // Filtros
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                // Búsqueda
                TextField(
                  decoration: const InputDecoration(
                    hintText: 'Buscar en logs...',
                    prefixIcon: Icon(Icons.search),
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (value) {
                    setState(() {
                      _searchQuery = value;
                    });
                  },
                ),
                const SizedBox(height: 12),
                // Filtro por nivel
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      _buildLevelChip(null, 'Todos', Icons.all_inclusive),
                      const SizedBox(width: 8),
                      _buildLevelChip(LogLevel.debug, 'Debug', Icons.bug_report),
                      const SizedBox(width: 8),
                      _buildLevelChip(LogLevel.info, 'Info', Icons.info),
                      const SizedBox(width: 8),
                      _buildLevelChip(
                          LogLevel.warning, 'Advertencias', Icons.warning),
                      const SizedBox(width: 8),
                      _buildLevelChip(LogLevel.error, 'Errores', Icons.error),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Contador
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            color: AppColors.surfaceVariant,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${filteredLogs.length} logs',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                Text(
                  'Total: ${logs.length}',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
          ),

          // Lista de logs
          Expanded(
            child: filteredLogs.isEmpty
                ? const Center(
                    child: Text('No hay logs para mostrar'),
                  )
                : ListView.separated(
                    itemCount: filteredLogs.length,
                    separatorBuilder: (context, index) => const Divider(height: 1),
                    itemBuilder: (context, index) {
                      final log = filteredLogs[index];
                      return _buildLogItem(log);
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildLevelChip(LogLevel? level, String label, IconData icon) {
    final isSelected = _selectedLevel == level;
    Color? color;

    if (level != null) {
      switch (level) {
        case LogLevel.debug:
          color = Colors.grey;
          break;
        case LogLevel.info:
          color = Colors.blue;
          break;
        case LogLevel.warning:
          color = Colors.orange;
          break;
        case LogLevel.error:
          color = Colors.red;
          break;
      }
    }

    return FilterChip(
      selected: isSelected,
      label: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16),
          const SizedBox(width: 4),
          Text(label),
        ],
      ),
      onSelected: (selected) {
        setState(() {
          _selectedLevel = selected ? level : null;
        });
      },
      backgroundColor: color?.withOpacity(0.1),
      selectedColor: color?.withOpacity(0.3),
    );
  }

  Widget _buildLogItem(LogEntry log) {
    Color levelColor;
    IconData levelIcon;

    switch (log.level) {
      case LogLevel.debug:
        levelColor = Colors.grey;
        levelIcon = Icons.bug_report;
        break;
      case LogLevel.info:
        levelColor = Colors.blue;
        levelIcon = Icons.info;
        break;
      case LogLevel.warning:
        levelColor = Colors.orange;
        levelIcon = Icons.warning;
        break;
      case LogLevel.error:
        levelColor = Colors.red;
        levelIcon = Icons.error;
        break;
    }

    return ExpansionTile(
      leading: Icon(levelIcon, color: levelColor),
      title: Text(
        log.message,
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
          fontWeight: log.level == LogLevel.error ? FontWeight.bold : null,
        ),
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (log.tag != null)
            Text(
              log.tag!,
              style: TextStyle(
                color: levelColor,
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          Text(
            '${log.timestamp.hour.toString().padLeft(2, '0')}:${log.timestamp.minute.toString().padLeft(2, '0')}:${log.timestamp.second.toString().padLeft(2, '0')}',
            style: const TextStyle(fontSize: 11),
          ),
        ],
      ),
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          color: levelColor.withOpacity(0.05),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Mensaje completo
              SelectableText(
                log.message,
                style: const TextStyle(fontFamily: 'monospace'),
              ),

              // Data
              if (log.data != null && log.data!.isNotEmpty) ...[
                const SizedBox(height: 12),
                Text(
                  'Data:',
                  style: Theme.of(context).textTheme.titleSmall,
                ),
                const SizedBox(height: 4),
                SelectableText(
                  log.data.toString(),
                  style: const TextStyle(fontFamily: 'monospace', fontSize: 12),
                ),
              ],

              // Error
              if (log.error != null) ...[
                const SizedBox(height: 12),
                Text(
                  'Error:',
                  style: Theme.of(context)
                      .textTheme
                      .titleSmall
                      ?.copyWith(color: Colors.red),
                ),
                const SizedBox(height: 4),
                SelectableText(
                  log.error.toString(),
                  style: const TextStyle(
                    fontFamily: 'monospace',
                    fontSize: 12,
                    color: Colors.red,
                  ),
                ),
              ],

              // Stack trace
              if (log.stackTrace != null) ...[
                const SizedBox(height: 12),
                Text(
                  'Stack Trace:',
                  style: Theme.of(context).textTheme.titleSmall,
                ),
                const SizedBox(height: 4),
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.black12,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: SelectableText(
                    log.stackTrace.toString(),
                    style: const TextStyle(
                      fontFamily: 'monospace',
                      fontSize: 10,
                    ),
                  ),
                ),
              ],

              // Botón copiar
              const SizedBox(height: 12),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton.icon(
                  icon: const Icon(Icons.copy, size: 16),
                  label: const Text('Copiar'),
                  onPressed: () {
                    Clipboard.setData(ClipboardData(text: log.toString()));
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Log copiado al portapapeles')),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  void _clearLogs() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Limpiar logs'),
        content: const Text('¿Estás seguro de que quieres eliminar todos los logs?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () {
              AppLogger.clearLogs();
              Navigator.pop(context);
              setState(() {});
            },
            child: const Text('Limpiar'),
          ),
        ],
      ),
    );
  }

  Future<void> _exportLogs(BuildContext context) async {
    try {
      final logsText = AppLogger.exportLogsAsText();
      final filePath = await AppLogger.getLogFilePath();

      if (filePath != null) {
        await Share.shareXFiles(
          [XFile(filePath)],
          subject: 'Logs de Finanzas App',
          text: 'Logs exportados',
        );
      } else {
        await Share.share(
          logsText,
          subject: 'Logs de Finanzas App',
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al exportar logs: $e')),
        );
      }
    }
  }
}
