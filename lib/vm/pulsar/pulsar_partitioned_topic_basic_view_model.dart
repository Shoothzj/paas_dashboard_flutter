import 'package:paas_dashboard_flutter/api/pulsar/pulsar_partitioned_topic_api.dart';
import 'package:paas_dashboard_flutter/module/pulsar/pulsar_namespace.dart';
import 'package:paas_dashboard_flutter/module/pulsar/pulsar_tenant.dart';
import 'package:paas_dashboard_flutter/module/pulsar/pulsar_topic.dart';
import 'package:paas_dashboard_flutter/persistent/po/pulsar_instance_po.dart';
import 'package:paas_dashboard_flutter/vm/base_load_view_model.dart';

class PulsarPartitionedTopicBasicViewModel extends BaseLoadViewModel {
  final PulsarInstancePo pulsarInstancePo;
  final TenantResp tenantResp;
  final NamespaceResp namespaceResp;
  final TopicResp topicResp;
  String partitionNum = "";
  double msgRateIn = 0;
  double msgRateOut = 0;
  int msgInCounter = 0;
  int msgOutCounter = 0;
  int storageSize = 0;

  PulsarPartitionedTopicBasicViewModel(this.pulsarInstancePo, this.tenantResp, this.namespaceResp, this.topicResp);

  PulsarPartitionedTopicBasicViewModel deepCopy() {
    return new PulsarPartitionedTopicBasicViewModel(
        pulsarInstancePo.deepCopy(), tenantResp.deepCopy(), namespaceResp.deepCopy(), topicResp.deepCopy());
  }

  int get id {
    return this.pulsarInstancePo.id;
  }

  String get name {
    return this.pulsarInstancePo.name;
  }

  String get host {
    return this.pulsarInstancePo.host;
  }

  int get port {
    return this.pulsarInstancePo.port;
  }

  String get tenant {
    return this.tenantResp.tenant;
  }

  String get namespace {
    return this.namespaceResp.namespace;
  }

  String get topic {
    return this.topicResp.topicName;
  }

  Future<void> fetchPartitions() async {
    try {
      final results = await PulsarPartitionedTopicApi.getBase(host, port, tenant, namespace, topic);
      partitionNum = results.partitionNum.toString();
      msgRateIn = results.msgRateIn;
      msgRateOut = results.msgRateOut;
      msgInCounter = results.msgInCounter;
      msgOutCounter = results.msgOutCounter;
      storageSize = results.storageSize;
      loadSuccess();
    } on Exception catch (e) {
      loadException = e;
      loading = false;
    }
    notifyListeners();
  }

  Future<void> modifyTopicPartition(String topic, int partition) async {
    try {
      await PulsarPartitionedTopicApi.modifyPartitionTopic(host, port, tenant, namespace, topic, partition);
      await fetchPartitions();
    } on Exception catch (e) {
      opException = e;
      notifyListeners();
    }
  }
}
